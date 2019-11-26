
//=require 'vendor/jquery'
//=require 'vendor/jquery.lazy.js'
//=require 'vendor/jquery.lazy.plugins.js'
//=require 'vendor/jquery.serializejson.js'
//=require 'vendor/autoresize.jquery.js'

$ ->

  $('.lazy').Lazy()
  # ScrollTop

  class ScrollTop
    constructor: () ->
      @registerEventHandler()
    registerEventHandler: () =>
      $(".scroll-top").click ->
        window.scrollTo { top: 0, behavior: 'smooth' }

  scrollTop = new ScrollTop

  # ScrollBottom

  class ScrollBottom
    constructor: () ->
      @registerEventHandler()
    registerEventHandler: () =>
      $(".scroll-bottom").click ->
        window.scrollTo { top: $(".teamt5-products").offset().top, behavior: 'smooth' }

  scrollBottom = new ScrollBottom

  # header

  class Header
    brand = "navbar-brand"
    menu = "navbar-menu"
    itemLink = "navbar-item-link"
    itemArrow = "navbar-item-arrow"
    burger = "navbar-burger"
    submenu = "navbar-submenu"
    submenuPadding = "navbar-submenu-padding"
    constructor: () ->
      @registerEventHandler()
    registerEventHandler: () =>
      $(".#{brand}").click ->
        $(".#{menu}").toggleClass("active")
        $(".#{burger}").toggleClass("active")
      $(".navbar-item-has-submenu").click (e) ->
        cur_navbar_submenu_active = $(e.currentTarget).children(".#{submenu}").hasClass("active")
        cur_navbar_submenu_padding_active = $(".#{submenuPadding}").hasClass("active")
        if !cur_navbar_submenu_active
          $(".#{itemLink}").removeClass("active")
          $(".#{submenu}").removeClass("active")
          $(".#{itemArrow}").removeClass("active")
        $(e.currentTarget).children(".#{itemLink}").toggleClass("active")
        $(e.currentTarget).find(".#{itemArrow}").toggleClass("active")
        $(e.currentTarget).children(".#{submenu}").toggleClass("active")
        if (cur_navbar_submenu_active && cur_navbar_submenu_padding_active) || (!cur_navbar_submenu_active && !cur_navbar_submenu_padding_active)
          $(".#{submenuPadding}").toggleClass("active")

  header = new Header

  # footer

  class Footer
    languageSelector = "language-selector"
    constructor: () ->
      @registerEventHandler()
      @locales = ["zh"]
    removeI18nFromPathname: (pathname) =>
      for i in [0...@locales.length]
        locale = @locales[i]
        if(pathname.search(locale) == 1)
          pathname = pathname.substring(locale.length + 1)
      return pathname

    registerEventHandler: () =>
      $("##{languageSelector}").change (e) =>
        i18n = $(e.currentTarget).val()
        origin = location.origin
        pathname = location.pathname
        pathname = @removeI18nFromPathname(pathname)
        url = origin + '/' + i18n + pathname
        window.location.href = url

  footer = new Footer

  # carousel

  class Carousel
    item = "carousel-item"
    items = "carousel-items"
    itemInformationContainer = "carousel-item-information-container"
    itemInformation = "carousel-item-information"
    itemIndicator = "carousel-indicator"
    duration = 200
    timerDuration = 5000
    constructor: () ->
      @count = $(".carousel .carousel-items").data('count')
      @curActiveIndex = 0
      @registerEventHandler()
      @startTimer()
      @ongoingTouches = []

    copyTouch: (touch) =>
      { identifier: touch.identifier, pageX: touch.pageX, pageY: touch.pageY }

    ongoingTouchIndexById: (idToFind) =>
      i = 0
      while i < @ongoingTouches.length
        id = @ongoingTouches[i].identifier
        if id == idToFind
          return i
        i++
      -1

    getItem: (index) ->
      $(".carousel-item[data-index=#{index}]")

    getItemInformationContainer: (index) ->
      $(".carousel-item[data-index=#{index}] .#{itemInformationContainer}")

    getItemInformation: (index) ->
      $(".carousel-item[data-index=#{index}] .#{itemInformation}")

    getItemIndicator: (index) ->
      $(".carousel-indicator[data-index=#{index}]")

    registerEventHandler: () =>
      $(".carousel").on "touchstart", (e) =>
        @stopTimer()
        touches = e.changedTouches
        for i in [0...touches.length]
          @ongoingTouches.push(@copyTouch(touches[i]))

      $(".carousel").on "touchend", (e) =>
        @startTimer()
        touches = e.changedTouches
        for i in [0...touches.length]
          touchstartIndex = @ongoingTouchIndexById(touches[i].identifier)
          if @ongoingTouches[touchstartIndex].pageX < touches[i].pageX
            @setActiveItem Math.max(@curActiveIndex - 1, 0)
          else if @ongoingTouches[touchstartIndex].pageX > touches[i].pageX
            @setActiveItem (@curActiveIndex + 1) % @count
          @ongoingTouches.splice(@ongoingTouchIndexById(touches[i].identifier), 1)

      $(".carousel").mouseenter () =>
        @stopTimer()
      .mouseleave () =>
        @startTimer()

      $(".carousel-indicator").click (e) =>
        index = $(e.currentTarget).data('index')
        @setActiveItem index

    startTimer: () =>
      @timer = setInterval =>
        @setActiveItem (@curActiveIndex + 1) % @count
      , timerDuration

    stopTimer: () =>
      clearInterval(@timer)

    resetTimer: () =>
      @stopTimer()
      @startTimer()

    slideItemLeftAndDisappear: (index) ->
      @getItem(index).addClass("left")
      new Promise((resolve) =>
        setTimeout =>
          @getItem(index).removeClass("active")
          @getItem(index).removeClass("left")
          resolve
        , duration
      )
    slideItemRightAndDisappear: (index) ->
      @getItem(index).addClass("right")
      new Promise((resolve) =>
        setTimeout =>
          @getItem(index).removeClass("active")
          @getItem(index).removeClass("right")
          resolve
        , duration
      )
    slideItemFromRightToCenter: (index) ->
      @getItem(index).addClass("right")
      @getItem(index).addClass("active")
      @getItemInformationContainer(index).addClass("left")
      @getItemInformation(index).addClass("bottom")
      new Promise((resolve) =>
        setTimeout =>
          @getItem(index).addClass("center")
        , 0
        setTimeout =>
          @getItem(index).removeClass("right")
          @getItem(index).removeClass("center")
          @getItemInformationContainer(index).addClass("center")
        , duration
        setTimeout =>
          @getItemInformationContainer(index).removeClass("left")
          @getItemInformationContainer(index).removeClass("center")
          @getItemInformation(index).addClass("center")
        , duration * 2
        setTimeout =>
          @getItemInformation(index).removeClass("bottom")
          @getItemInformation(index).removeClass("center")
          resolve
        , duration * 3
      )
    slideItemFromLeftToCenter: (index) ->
      @getItem(index).addClass("left")
      @getItem(index).addClass("active")
      @getItemInformationContainer(index).addClass("left")
      @getItemInformation(index).addClass("bottom")
      new Promise((resolve) =>
        setTimeout =>
          @getItem(index).addClass("center")
        , 0
        setTimeout =>
          @getItem(index).removeClass("left")
          @getItem(index).removeClass("center")
          @getItemInformationContainer(index).addClass("center")
        , duration
        setTimeout =>
          @getItemInformationContainer(index).removeClass("left")
          @getItemInformationContainer(index).removeClass("center")
          @getItemInformation(index).addClass("center")
        , duration * 2
        setTimeout =>
          @getItemInformation(index).removeClass("bottom")
          @getItemInformation(index).removeClass("center")
          resolve
        , duration * 3
      )

    setActiveItem: (index) ->
      @getItemIndicator(@curActiveIndex).removeClass("active")
      @getItemIndicator(index).addClass("active")
      if @curActiveIndex == index
        return
      else if @curActiveIndex < index
        # coffeescript gem doesn't support await
        Promise.all([@slideItemLeftAndDisappear @curActiveIndex, @slideItemFromRightToCenter index])
      else
        Promise.all([@slideItemRightAndDisappear @curActiveIndex, @slideItemFromLeftToCenter index])
      @curActiveIndex = index

  carousel = new Carousel
  $('textarea').autoResize()

  # form

  class Form
    formSubmit = "form-submit"
    formSubmitLoading = "form-submit-loading"
    formSubmitText = "form-submit-text"
    constructor: (formName, googleSheetUrl) ->
      @formName = formName
      @googleSheetUrl = googleSheetUrl
      @registerEventHandler()

    validateInputs: (data) =>
      valid = true
      for key, value of data
        if value.length == 0
          valid = false
          $(".form-input[name=#{key}]").addClass("form-input-error")
          $(".form-input-error-message[name=#{key}]").text("* Required field")
      return valid
    clearInputError: () =>
      $(".form-input").removeClass("form-input-error")
      $(".form-input-error-message").text("")
    submitData: (googleSheetUrl, data, e) =>
      window.requestAnimationFrame( () =>
        $(e.currentTarget).children(".#{formSubmitLoading}").addClass('active')
        $(e.currentTarget).children(".#{formSubmitText}").text('')
      )
      $.get googleSheetUrl, data
        .done (response) ->
          $(e.currentTarget).prop('disabled', true)
          $(e.currentTarget).addClass('success')
          $(e.currentTarget).children(".#{formSubmitText}").text('Success')
        .fail (response) ->
          $(e.currentTarget).addClass('error')
          $(e.currentTarget).children(".#{formSubmitText}").text('Error')
        .always () ->
          $(e.currentTarget).children(".#{formSubmitLoading}").removeClass('active')

    registerEventHandler: () =>
      $("##{@formName}-submit").click (e) =>
        e.preventDefault()
        @clearInputError()
        data = $("##{@formName}").serializeJSON()
        if !@validateInputs(data)
          return
        @submitData @googleSheetUrl, data, e

  threatsonarContactUsForm = new Form "threatsonar-contact-us-form", "https://script.google.com/a/teamt5.org/macros/s/AKfycbzn7LjNQ5YQR97mQERARgPmsA8n3U7EyrN63x1Adw/exec"

  threatvisionContactUsForm = new Form "threatvision-contact-us-form", "https://script.google.com/a/teamt5.org/macros/s/AKfycbw5tsN8yq4g5D5XCoIsn0DPold7kgpBbuDCXqVL/exec"

  positionForm = new Form "position-form", "https://script.google.com/a/teamt5.org/macros/s/AKfycbyhx4Py9s91JBYEEZiKVqf7fgbaq0ENK2hwRP_S/exec"
