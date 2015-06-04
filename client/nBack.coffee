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
      window.gameArray = new Array
      window.populateArray(window.gameArray)
      console.log 'your game array is this length'
      console.log window.gameArray.length
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

      #window.imageContent= '<p>Image ' + window.i + ' of blah</p><img src="bart.svg" height="200" width="200">'


      window.frontSurface = new Famous.Surface(
        size: [
          200
          200
        ]
        content: window.imageContent
        properties:
          background: '#262626'
          color: 'white'
          lineHeight: '200px'
          textAlign: 'center')

      #window.imageContent= '<p>Image ' + window.i + 'of blah</p><img src="homer.svg" height="200" width="200">'


      backSurface = new Famous.Surface(
        size: [
          200
          200
        ]
        content: window.imageContent
        properties:
          background: '#262626'
          color: 'white'
          lineHeight: '200px'
          textAlign: 'center')

      flipper.setFront window.frontSurface
      flipper.setBack backSurface

      centerModifier = new Famous.Modifier(
        align: [
          .5
          .5
        ]
        origin: [
          .5
          .0
        ])

      toggle = false
      console.log ' made it past adds'

      ###
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
      ###
      ###
      timer= Famous.Timer
      i = 0



      while i <  window.gameArray.length

        timer.debounce(swapImage(i),3000)


        #backSurface.setContent(window.imageContent)
        i++


      timer.clear(swapImage(i))
      ###
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

swapImage =  ->
       console.log 'swap index is '
       current= String(window.i+1)
       total = String(window.gameArray.length)
       console.log(window.i)
       switch window.gameArray[window.i]
         when 0
           window.imageContent= 'Image ' + current + ' of '  + total + '<img src="bart.svg" height="200" width="200">'
         when 1
           window.imageContent= 'Image ' + current + ' of ' + total + '<img src="homer.svg" height="200" width="200">'
         when 2
           window.imageContent= 'Image ' + current + ' of ' + total + '<img src="octocat.svg" height="200" width="200">'
         when 3
           window.imageContent= 'Image ' + current + ' of ' + total + '<img src="homer.svg" height="200" width="200">'

       console.log 'in swap and your image is '
       console.log window.imageContent
       window.frontSurface.setContent(window.imageContent)
       console.log 'made it past setcontent'
       window.i++
       if window.i > window.gameArray.length
           Meteor.clearInterval window.intervalID


Template.genimage.helpers = ->
   next_image: () ->
     ###
     timer= Famous.Timer
     i = 0



     while i <  window.gameArray.length
       console.log 'in while loop'
       timer.debounce(swapImage(i),3000)


       #backSurface.setContent(window.imageContent)
       i++


     timer.clear(swapImage(i))
     ###










Template.nBack.rendered = ->

# create our context for famo.us to use - the context will contain a single view that contains
# our entire render tree that defines our app
# set the perspective so the rotation animation works

  #nBack.mainContext = Famous.Engine.createContext()
  #nBack.mainContext.setPerspective 500

# create a new instance of our app view that gets rendered into the context
  nBackViews = new nBack.modifier
# add the view to the   to start the rendering and processing of our app by famo.us
  nBack.mainContext.add nBackViews


  #timer= Famous.Timer
  window.i = 0

  window.intervalID=0

  window.intervalID=Meteor.setInterval(swapImage,300)

  return
  ###
  while i <  window.gameArray.length
    console.log 'in while loop'
    window.frontSurface.setContent(window.imageContent)
    timer.debounce(swapImage(i),300000)


         #backSurface.setContent(window.imageContent)
    i++
  ###

  #timer.clear(swapImage(i))
