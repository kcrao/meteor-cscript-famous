
window.App ?= {}
window.Famous ?={}
 
Meteor.startup ->  
  Famous.Engine = famous.core.Engine
  Famous.View = famous.core.View
  Famous.Surface = famous.core.Surface
  Famous.Modifier = famous.core.Modifier
  Famous.Transform = famous.core.Transform
  Famous.Draggable = famous.modifiers.Draggable
  Famous.StateModifier = famous.modifiers.StateModifier
  Famous.ModifierChain = famous.modifiers.ModifierChain
  Famous.RenderController = famous.views.RenderController
  Famous.EventHandler = famous.core.EventHandler
 
  Famous.Scrollview = famous.views.Scrollview
  Famous.HeaderFooterLayout = famous.views.HeaderFooterLayout
 
  Famous.Easing = famous.transitions.Easing
  Famous.Transitionable = famous.transitions.Transitionable
 
  Famous.GenericSync     = famous.inputs.GenericSync
  Famous.MouseSync = famous.inputs.MouseSync
  Famous.TouchSync = famous.inputs.TouchSync
 
 
  Famous.Timer           = famous.utilities.Timer
 
 
 
  Famous.Transitionable.registerMethod 'spring',famous.transitions.SpringTransition
 
  Famous.GenericSync.register
    mouse: Famous.MouseSync
    touch: Famous.TouchSync
 


# define our 'home' path template for iron:router
 

Router.route 'clickBox',
    path: '/',
    template: 'home'



Meteor.startup  -> 
#creates a famous view
# define our class in the App namespace
  class App.modifier extends Famous.View
    DEFAULT_OPTIONS:
      content: undefined
    constructor: (@options) ->
      super @options
      for key, val of @DEFAULT_OPTIONS
        @options[key] = @options[key] ? val
      @createPage()
 
#class methods follow
    createPage: ->
 
# static variables
      defaultd = -60
      degtorad = 0.0174533
      size = [300, 400]
        
# state variables
      @angled = new Famous.Transitionable defaultd
      @isToggled = false
  
#KRAO Added Render Controller

      renderController = new Famous.RenderController

 
#create our surfaces 
# create red card surface
      redCardSurface = new Famous.Surface
          size: size
          content: 'Click Me'
          properties:
              fontSize: '26px'
              paddingTop: '40px'
              color: 'white'
              textAlign: 'center'
              backgroundColor: '#FA5C4F'
              cursor: 'pointer'
              border: 'solid 2px black'
              borderRadius: '20px'
# rotates red card surface
# this is actually 4 modifiers in one (size,origin,align,and transform)
      redCardRotationModifier = new Famous.Modifier
          size: size,
          origin: [0.5, 0.5]
          align: [0.5, 0.5]
 
      renderController.show(redCardSurface)
  
# add a transform to the modifier to do the rotation. note this is a transformFrom callback
# so it gets evaluated 60 times a second. we will use our transitionable ('angled') to get the rotation angle
# the rotate transform takes a value in 'radians' so we have to convert our 'degrees' to radians.
      redCardRotationModifier.transformFrom =>
          return Famous.Transform.rotateY @angled.get()*degtorad
     
   
# create our circle
      circle = new Famous.Surface
          size : [200, 200]
          properties :
              backgroundColor: 'white'
              borderRadius: '100px'
              pointerEvents : 'none'
              textAlign: 'center'
              paddingTop: '50px'
              fontSize: 'x-large'
              border: 'solid 2px green'
# shows that we can render an HTML template into the surface content
      circle.setContent Blaze.toHTML(Template.imacircle)
 
#scales circle based on angle of rotation
      circleScaleModifier = new Famous.Modifier
          origin: [0.5, 0.5]
          align: [0.5, 0.5]
        # this is a callback so it is the same as a transformForm function executed 60 times a second
          transform: =>
              scale = Math.cos @angled.get()*degtorad
              # we scale the X and Y sizes 
              return Famous.Transform.scale scale, scale
      # this is needed on order to keep the circle in front of the box
      # the z value of 90 is to fix the safari bug (so box doesn't clip it)
      circleTranslateModifier = new Famous.Modifier
          transform: Famous.Transform.translate 0, 0, 90 
      
 
#create our click handler for the red card 
      redCardSurface.on 'click', =>
            ###
            if @isToggled is on
              targetAngle = defaultd
            else
              targetAngle = -defaultd
            # if the animation is currently in progress when box is clicked
            # halt it and restart it (the direction will reverse)
            if (@angled.isActive())
              @angled.halt()
            @angled.set targetAngle, { duration: 2000, curve: 'easeInOut' }
            @isToggled = ! @isToggled
            ###
            renderController.hide(redCardSurface)
            renderController.hide(circle)
       
            
            Router.go '/nBack'    
            
 #build our render tree
 #  view -> modifier(s) -> surface
 # the '@' symbol means 'this.' so @add means this.add which adds the modifiers and surface 
 # to our new view object when it gets created
      @add(redCardRotationModifier).add(renderController).add redCardSurface
 #chain the modifiers so the circle is both scaled and translated (z = 90)
      @add(circleScaleModifier).add(circleTranslateModifier).add(circle).add renderController


Template.home.rendered = ->

# create our context for famo.us to use - the context will contain a single view that contains 
# our entire render tree that defines our app
# set the perspective so the rotation animation works

  App.mainContext = Famous.Engine.createContext()
  App.mainContext.setPerspective 1000

# create a new instance of our app view that gets rendered into the context
  appViews = new App.modifier

# add the view to the context to start the rendering and processing of our app by famo.us
  App.mainContext.add appViews