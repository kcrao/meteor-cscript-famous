window.nBack ?= {}
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
  Famous.Flipper = famous.views.Flipper
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




Router.route 'nBack',
    path: '/nBack',
    template: 'nBack'



Meteor.startup  ->

  nBack.mainContext = Famous.Engine.createContext()
  nBack.mainContext.setPerspective 500

#Adding a comment la la la
#creates a famous view
# define our class in the nBack namespace
  class nBack.modifier extends Famous.View
    DEFAULT_OPTIONS:
      content: undefined
    constructor: (@options) ->
      super @options
      for key, val of @DEFAULT_OPTIONS
        @options[key] = @options[key] ? val
      @createPage()

#class methods follow
    createPage: ->
      #gameArray = new Array
      gameArray = window.populateArray()
      console.log gameArray.length
# static variables
      defaultd = -60
      degtorad = 0.0174533
      size = [300, 400]

#state variables
      @angled = new Famous.Transitionable defaultd
      @isToggled = false
      console.log 'in nback create page'
# KRAO Added RenderController
      window.flipRC= new Famous.RenderController
      window.flipper = new Famous.Flipper
      flipperView = new Famous.View

      imageContent= '<img src="bart.svg" height="200" width="200">'


      frontSurface = new Famous.Surface(
        size: [
          200
          200
        ]
        content: imageContent
        properties:
          background: 'black'
          color: 'white'
          lineHeight: '200px'
          textAlign: 'center')

      imageContent= '<img src="homer.svg" height="200" width="200">'


      backSurface = new Famous.Surface(
        size: [
          200
          200
        ]
        content: imageContent
        properties:
          background: 'black'
          color: 'white'
          lineHeight: '200px'
          textAlign: 'center')

      window.flipper.setFront frontSurface
      window.flipper.setBack backSurface

      centerModifier = new Famous.Modifier(
        align: [
          .5
          .5
        ]
        origin: [
          .5
          .5
        ])

      toggle = false
      console.log ' made it past adds'

      frontSurface.on 'click', =>
        angle = if toggle then 0 else Math.PI
        window.flipper.setAngle angle,
          curve: 'easeOutBounce'
          duration: 500
        toggle = !toggle

      backSurface.on 'click', =>
        angle = if toggle then 0 else Math.PI
        window.flipper.setAngle angle,
          curve: 'easeOutBounce'
          duration: 500
        toggle = !toggle

      window.flipRC.show(window.flipper)
      @add(centerModifier).add(window.flipRC).add(window.flipper)
      console.log 'past event'


 #build our render tree
 #  view -> modifier(s) -> surface
 # the '@' symbol means 'this.' so @add means this.add which adds the modifiers and surface
 # to our new view object when it gets created
 #      @add(blueCardRotationModifier).add(renderController).add blueCardSurface
 #chain the modifiers so the circle is both scaled and translated (z = 90)
 #     @add(circleScaleModifier).add(circleTranslateModifier).add(renderController2).add circle





Template.nBack.rendered = ->

# create our context for famo.us to use - the context will contain a single view that contains
# our entire render tree that defines our app
# set the perspective so the rotation animation works

  #nBack.mainContext = Famous.Engine.createContext()
  #nBack.mainContext.setPerspective 500

# create a new instance of our app view that gets rendered into the context
  nBackViews = new nBack.modifier
# add the view to the context to start the rendering and processing of our app by famo.us
  nBack.mainContext.add nBackViews
