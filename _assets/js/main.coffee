
//=require 'vendor/jquery'
//=require 'vendor/jquery.serializejson.js'
//=require 'vendor/autoresize.jquery.js'

$ ->
	$(".scroll-top").click ->
		window.scrollTo {top: 0, behavior: 'smooth'}

	$(".scroll-bottom").click ->
		window.scrollTo {top: $(".teamt5-products").offset().top, behavior: 'smooth'}

	# header

	$(".navbar-brand").click ->
		$(".navbar-menu").toggleClass('navbar-menu-active')
		$(".navbar-burger").toggleClass('navbar-burger-active')

	$(".navbar-item-has-submenu").click (e) ->
		cur_navbar_submenu_active = $(e.currentTarget).children(".navbar-submenu").hasClass('navbar-submenu-active')
		cur_navbar_submenu_padding_active = $(".navbar-submenu-padding").hasClass('navbar-submenu-padding-active')
		if !cur_navbar_submenu_active
			$(".navbar-item-link").removeClass('navbar-item-link-active')
			$(".navbar-submenu").removeClass('navbar-submenu-active')
			$(".navbar-item-arrow").removeClass('navbar-item-arrow-active')

		$(e.currentTarget).children(".navbar-item-link").toggleClass('navbar-item-link-active')
		$(e.currentTarget).find(".navbar-item-arrow").toggleClass('navbar-item-arrow-active')
		$(e.currentTarget).children(".navbar-submenu").toggleClass('navbar-submenu-active')

		if (cur_navbar_submenu_active && cur_navbar_submenu_padding_active) || (!cur_navbar_submenu_active && !cur_navbar_submenu_padding_active)
			$(".navbar-submenu-padding").toggleClass('navbar-submenu-padding-active')

	# footer
	class Footer
		constructor: () ->
			@registerEventHandler()
			@locales = ["zh"]
		removeI18nFromPathname: (pathname) =>
			for i in [0...@locales.length]
				locale = @locales[i]
				if(pathname.search(locale)==1)
					pathname = pathname.substring(locale.length+1)
			return pathname

		registerEventHandler: () =>
			$("#language-selector").change (e) =>
				i18n = $(e.currentTarget).val()
				origin = location.origin
				pathname = location.pathname
				pathname = @removeI18nFromPathname(pathname)
				url = origin + '/' + i18n + pathname
				console.log(url)
				window.location.href = url

	footer = new Footer


	# carousel

	class Carousel
		item = "carousel-item"
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
			@stopTimer()
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
			$(".carousel-item[data-index=#{index}] .carousel-item-information-container")

		getItemInformation: (index) ->
			$(".carousel-item[data-index=#{index}] .carousel-item-information-container .carousel-item-information")

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
						@setActiveItem Math.max(@curActiveIndex-1,0)
					else if @ongoingTouches[touchstartIndex].pageX > touches[i].pageX
						@setActiveItem (@curActiveIndex+1)%@count
					@ongoingTouches.splice(@ongoingTouchIndexById(touches[i].identifier),1)

			$(".carousel").mouseenter () =>
				@stopTimer()
			.mouseleave () =>
				@startTimer()

			$(".carousel-indicator").click (e) =>
				index = $(e.currentTarget).data('index')
				@setActiveItem index

		startTimer: () =>
			@timer = setInterval =>
				@setActiveItem (@curActiveIndex+1)%@count
			, timerDuration

		stopTimer: () =>
			clearInterval(@timer)

		resetTimer: () =>
			@stopTimer()
			@startTimer()

		slideItemLeftAndDisappear: (index) ->
			@getItem(index).addClass("#{item}-left")
			new Promise((resolve)=>
				setTimeout =>
					@getItem(index).removeClass("#{item}-active")
					@getItem(index).removeClass("#{item}-left")
					resolve
				, duration
			)
		slideItemRightAndDisappear: (index) ->
			@getItem(index).addClass("#{item}-right")
			new Promise((resolve)=>
				setTimeout =>
					@getItem(index).removeClass("#{item}-active")
					@getItem(index).removeClass("#{item}-right")
					resolve
				, duration
			)
		slideItemFromRightToCenter: (index) ->
			@getItem(index).addClass("#{item}-right #{item}-active")
			@getItemInformationContainer(index).addClass("#{itemInformationContainer}-left")
			@getItemInformation(index).addClass("#{itemInformation}-bottom")
			new Promise((resolve)=>
				setTimeout =>
					@getItem(index).addClass("#{item}-center")
				, 0
				setTimeout =>
					@getItem(index).removeClass("#{item}-right")
					@getItem(index).removeClass("#{item}-center")
					@getItemInformationContainer(index).addClass("#{itemInformationContainer}-center")
				, duration
				setTimeout =>
					@getItemInformationContainer(index).removeClass("#{itemInformationContainer}-left")
					@getItemInformationContainer(index).removeClass("#{itemInformationContainer}-center")
					@getItemInformation(index).addClass("#{itemInformation}-center")
				, duration*2
				setTimeout =>
					@getItemInformation(index).removeClass("$itemInformation-bottom")
					@getItemInformation(index).removeClass("$itemInformation-center")
					resolve
				, duration*3
			)
		slideItemFromLeftToCenter: (index) ->
			@getItem(index).addClass("#{item}-left #{item}-active")
			@getItemInformationContainer(index).addClass("#{itemInformationContainer}-left")
			@getItemInformation(index).addClass("#{itemInformation}-bottom")
			new Promise((resolve)=>
				setTimeout =>
					@getItem(index).addClass("#{item}-center")
				, 0
				setTimeout =>
					@getItem(index).removeClass("#{item}-left")
					@getItem(index).removeClass("#{item}-center")
					@getItemInformationContainer(index).addClass("#{itemInformationContainer}-center")
				, duration
				setTimeout =>
					@getItemInformationContainer(index).removeClass("#{itemInformationContainer}-left")
					@getItemInformationContainer(index).removeClass("#{itemInformationContainer}-center")
					@getItemInformation(index).addClass("#{itemInformation}-center")
				, duration*2
				setTimeout =>
					@getItemInformation(index).removeClass("#{itemInformation}-bottom")
					@getItemInformation(index).removeClass("#{itemInformation}-center")
					resolve
				, duration*3
			)

		setActiveItem: (index) ->
			@getItemIndicator(@curActiveIndex).removeClass("#{itemIndicator}-active")
			@getItemIndicator(index).addClass("#{itemIndicator}-active")
			if @curActiveIndex==index
				return
			else if @curActiveIndex < index
				# coffeescript gem doesn't support await
				Promise.all([@slideItemLeftAndDisappear @curActiveIndex, @slideItemFromRightToCenter index])
			else
				Promise.all([@slideItemRightAndDisappear @curActiveIndex, @slideItemFromLeftToCenter index])
			@curActiveIndex = index

	carousel = new Carousel
	$('textarea').autoResize();

	# form

	class Form
		constructor: (formName,googleSheetUrl) ->
			@formName = formName
			@googleSheetUrl = googleSheetUrl
			@registerEventHandler()

		validateInputs: (data) =>
			valid = true
			for key,value of data
				if value.length == 0
					valid = false
					$(".form-input[name=#{key}]").addClass("form-input-error")
					$(".form-input-error-message[name=#{key}]").text("* Required field")
			return valid
		clearInputError: () =>
			$(".form-input").removeClass("form-input-error")
			$(".form-input-error-message").text("")
		registerEventHandler: () =>
			$("##{@formName}-submit").click (e) =>
				e.preventDefault();
				@clearInputError()
				data = $("##{@formName}").serializeJSON()
				if !@validateInputs(data)
					return
				$.get
					url: @googleSheetUrl
					data: data
					dataType: "JSON"
					success: (response) ->
						$(e.currentTarget).prop('disabled', true)
						$(e.currentTarget).addClass('button-success')
						$(e.currentTarget).text('Success')
					error: (response) ->
						$(e.currentTarget).addClass('error')
						$(e.currentTarget).text('Error')

	threatsonarContactUsForm = new Form("threatsonar-contact-us-form","https://script.google.com/a/teamt5.org/macros/s/AKfycbzn7LjNQ5YQR97mQERARgPmsA8n3U7EyrN63x1Adw/exec")

	threatvisionContactUsForm = new Form("threatvision-contact-us-form","https://script.google.com/a/teamt5.org/macros/s/AKfycbw5tsN8yq4g5D5XCoIsn0DPold7kgpBbuDCXqVL/exec")

	positionForm = new Form("position-form","https://script.google.com/a/teamt5.org/macros/s/AKfycbyhx4Py9s91JBYEEZiKVqf7fgbaq0ENK2hwRP_S/exec")
