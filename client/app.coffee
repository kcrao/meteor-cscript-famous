
window.App ?= {}
window.Famous ?={}

Meteor.startup ->
  Famous.Engine = famous.core.Engine
  Famous.View = famous.core.View
  Famous.Surface = famous.core.Surface
  Famous.Modifier = famous.core.Modifier
  Famous.Transform = famous.core.transform
  Famous.Draggable = famous.modifiers.Draggable
  Famous.StateModifier = famous.modifiers.StateModifier
  Famous.ModifierChain = famous.modifiers.ModifierChain
  Famous.RenderController = famous.views.RenderController
  Famous.EventHandler = famous.core.EventHandler


  Famous.ContainerSurface = famous.surfaces.ContainerSurface
  Famous.SequentialLayout = famous.views.SequentialLayout
  Famous.HeaderFooterLayout = famous.views.HeaderFooterLayout

  Famous.Scrollview = famous.views.Scrollview


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


Router.route 'main',
    path: '/',
    template: 'home'


Meteor.startup  ->
#creates a famous view
# define our class in the App namespace
  App.mainContext = Famous.Engine.createContext()
  App.mainContext.setPerspective 1000



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
      size = [450, window.innerHeight-430]

# state variables
      @angled = new Famous.Transitionable defaultd
      @isToggled = false

#KRAO Added Render Controller and Container Surface
     # pageContainer=new Famous.ContainerSurface
      #    size: size
       #   origin: [0.5, 0.5]
       #   align: [0.5,0.5]

      renderController = new Famous.RenderController
      renderController2= new Famous.RenderController
      headerRenderController = new Famous.RenderController
      menuRenderController = new Famous.RenderController
      menuLeftRenderController = new Famous.RenderController
      pageView = new Famous.View


#create our surfaces

      sequentialLayout= new Famous.SequentialLayout

#KRAO Create array of surfaces

#      surfaces =
#           first:
#             name: "About"
#              image: "question.png"
 #          second:
 #             name: "LeaderBoard"
 #             image: "leader.png"
 #          third:
 #             name: "Settings"
 #             image: "settings.png"
 #          fourth:
 #             name: "Play Game"
 #             image: "playgame.png"
      surfaces=[]


      menuModifier = new Famous.Modifier
         transform: Famous.Transform.thenMove(famous.core.Transform.rotateZ(320.40), [0, 95, 0]),
         #duration: 12000



      sequentialLayout.sequenceFrom surfaces

      menuItems = [
          'About'
          'LeaderBoard'
          'Play Game'
          'Settings'
      ]
      iconItems = [
           'about.png',
           'friends.png',
           'starred.png',
           'settings.png'
      ]

      for i in [0...4]
          surfaces.push new Famous.Surface(
            content:  '<img src="' +iconItems[i] + '" height="17" width="17"> &nbsp; &nbsp; &nbsp;' +    menuItems[i]
            size: [
              330
              window.innerHeight / 12
            ]
            properties:
              #backgroundColor: '#ABD4ED'
              backgroundColor: '#47476B'
              lineHeight: window.innerHeight / 10 + 'px'
              textAlign: 'center'
              border: 'solid 1px black'
              borderRadius: '1px')


      surfaces[0].on 'click', =>
              alert "You clicked on Alert"
      surfaces[1].on 'click', =>
              alert "You clicked on LeaderBoard"
      surfaces[2].on 'click', =>

              menuRenderController.hide(sequentialLayout)

              #menuLeftRenderController.hide(menuLeftSurface)
              renderController.hide(redCardSurface)

              Router.go '/nBack'
      surfaces[3].on 'click', =>
              alert "You clicked on Settings"
# create red card surface
      menuLeftModifier = new Famous.Modifier
          transform: Famous.Transform.translate 1, 93, 0

      menuLeftSurface = new Famous.Surface
          size: [35,307]
          properties:
              backgroundColor: 'black'
              borderRight: 'solid 1px black'




      redCardSurface = new Famous.Surface
          size: size
          content: 'Train your Mind with BrainBusters'
          properties:
              fontSize: '26px'
              paddingTop: '20px'
              color: 'black'
              textAlign: 'center'
              backgroundColor: 'black'
              #cursor: 'pointer'
              border: 'solid 1px black'
              #borderTop: 'solid 6px black'
              borderRadius: '2px'
# rotates red card surface
# this is actually 4 modifiers in one (size,origin,align,and transform)
      redCardRotationModifier = new Famous.Modifier
        #  size: size,
        #  origin: [0.54, 0.35]
        #  align: [0.54, 0.35]
           transform: Famous.Transform.translate 330, 82, 0



      @add(redCardRotationModifier).add(renderController).add(pageView).add redCardSurface
 #chain the modifiers so the circle is both scaled and translated (z = 90)


      @add(menuModifier).add(menuRenderController).add(sequentialLayout)
      #@add(menuLeftModifier).add(menuLeftRenderController).add menuLeftSurface
      @add(menuLeftModifier).add(menuLeftRenderController).add menuLeftSurface


      renderController.show(redCardSurface)

      menuRenderController.show(sequentialLayout)
      menuLeftRenderController.show(menuLeftSurface)



Template.layout.rendered = ->



  buttonSurface = new Famous.Surface
     size: [
        50
        50
     ]
     properties:
        backgroundColor: '#262626'
        marginTop: '10px'
        marginLeft: '10px'

  buttonSurface.setContent Blaze.toHTML(Template.homeButton)

  containSurface = new Famous.ContainerSurface
   size: [
        undefined
        70
     ]
   properties:
         #backgroundColor: '#47476B'
         backgroundColor: '#262626'
         textAlign: 'center'


  headerSurface = new Famous.Surface
     size: [
        undefined
        70
     ]
     content: '<h2>Welcome to BrainBusters<h2>'
     properties:
         #backgroundColor: '#47476B'
         backgroundColor: '#262626'
         textAlign: 'center'

  containSurface.add(buttonSurface)
  #containSurface.add(headerSurface)

  buttonSurface.on 'click', =>


            #renderController2.hide(circle)
            #renderController.hide(redCardSurface)
            #renderController.hide(pageView)
            currentRoute=Router.current()
            window.flipRC.hide(window.flipper) ? window.flipRC
            console.log currentRoute
            Router.go '/'


  App.mainContext.add containSurface




Template.home.rendered = ->

# create our context for famo.us to use - the context will contain a single view that contains
# our entire render tree that defines our app
# set the perspective so the rotation animation works

  #App.mainContext = Famous.Engine.createContext()
  #App.mainContext.setPerspective 1000

# create a new instance of our app view that gets rendered into the context
  appViews = new App.modifier

# add the view to the context to start the rendering and processing of our app by famo.us
  App.mainContext.add(appViews)
