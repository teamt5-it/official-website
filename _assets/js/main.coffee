
//=require 'vendor/jquery'
//=require 'vendor/jquery.serializejson.js'
//=require 'vendor/autoresize.jquery.js'

$ ->
	$(".scroll-top").click ->
		window.scrollTo {top: 0, behavior: 'smooth'}

	$(".scroll-bottom").click ->
		window.scrollTo {top: $(".products").offset().top, behavior: 'smooth'}

	# header

	$(".navbar-brand").click ->
		$(".navbar-menu").toggleClass('active')
		$(".navbar-burger").toggleClass('active')

	$(".navbar-item-has-submenu").click (e) ->
		cur_navbar_submenu_active = $(e.currentTarget).children(".navbar-submenu").hasClass('active')
		cur_navbar_submenu_padding_active = $(".navbar-submenu-padding").hasClass('active')
		if !cur_navbar_submenu_active
			$(".navbar-item-link").removeClass('active')
			$(".navbar-submenu").removeClass('active')
			$(".navbar-item-arrow").removeClass('active')

		$(e.currentTarget).children(".navbar-item-link").toggleClass('active')
		$(e.currentTarget).find(".navbar-item-arrow").toggleClass('active')
		$(e.currentTarget).children(".navbar-submenu").toggleClass('active')

		if (cur_navbar_submenu_active && cur_navbar_submenu_padding_active) || (!cur_navbar_submenu_active && !cur_navbar_submenu_padding_active)
			$(".navbar-submenu-padding").toggleClass('active')

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
		duration = 200
		timer_duration = 5000
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
			$(".carousel .carousel-items .carousel-item[data-index=#{index}]")

		getItemTitleContainer: (index) ->
			$(".carousel .carousel-items .carousel-item[data-index=#{index}] .carousel-item-information-container")

		getItemTitle: (index) ->
			$(".carousel .carousel-items .carousel-item[data-index=#{index}] .carousel-item-information-container .carousel-item-information")

		getItemIndicator: (index) ->
			$(".carousel .carousel-indicators .carousel-indicator[data-index=#{index}]")

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

			$(".carousel .carousel-indicators .carousel-indicator").click (e) =>
				index = $(e.currentTarget).data('index')
				@setActiveItem index

		startTimer: () =>
			@timer = setInterval =>
				@setActiveItem (@curActiveIndex+1)%@count
			, timer_duration

		stopTimer: () =>
			clearInterval(@timer)

		resetTimer: () =>
			@stopTimer()
			@startTimer()

		slideItemLeftAndDisappear: (index) ->
			@getItem(index).addClass('left')
			new Promise((resolve)=>
				setTimeout =>
					@getItem(index).removeClass('active')
					@getItem(index).removeClass('left')
					resolve
				, duration
			)
		slideItemRightAndDisappear: (index) ->
			@getItem(index).addClass('right')
			new Promise((resolve)=>
				setTimeout =>
					@getItem(index).removeClass('active')
					@getItem(index).removeClass('right')
					resolve
				, duration
			)
		slideItemFromRightToCenter: (index) ->
			@getItem(index).addClass('right active')
			@getItemTitleContainer(index).addClass('left')
			@getItemTitle(index).addClass('bottom')
			new Promise((resolve)=>
				setTimeout =>
					@getItem(index).addClass('center')
				, 0
				setTimeout =>
					@getItem(index).removeClass('right')
					@getItem(index).removeClass('center')
					@getItemTitleContainer(index).addClass('center')
				, duration
				setTimeout =>
					@getItemTitleContainer(index).removeClass('left')
					@getItemTitleContainer(index).removeClass('center')
					@getItemTitle(index).addClass('center')
				, duration*2
				setTimeout =>
					@getItemTitle(index).removeClass('bottom')
					@getItemTitle(index).removeClass('center')
					resolve
				, duration*3
			)
		slideItemFromLeftToCenter: (index) ->
			@getItem(index).addClass('left active')
			@getItemTitleContainer(index).addClass('left')
			@getItemTitle(index).addClass('bottom')
			new Promise((resolve)=>
				setTimeout =>
					@getItem(index).addClass('center')
				, 0
				setTimeout =>
					@getItem(index).removeClass('left')
					@getItem(index).removeClass('center')
					@getItemTitleContainer(index).addClass('center')
				, duration
				setTimeout =>
					@getItemTitleContainer(index).removeClass('left')
					@getItemTitleContainer(index).removeClass('center')
					@getItemTitle(index).addClass('center')
				, duration*2
				setTimeout =>
					@getItemTitle(index).removeClass('bottom')
					@getItemTitle(index).removeClass('center')
					resolve
				, duration*3
			)

		setActiveItem: (index) ->
			@getItemIndicator(@curActiveIndex).removeClass('active')
			@getItemIndicator(index).addClass('active')
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

	# threatsonar-contact-us-form
	$("#threatsonar-contact-us-form-submit").click (e) ->
		e.preventDefault();
		data = $("#threatsonar-contact-us-form").serializeJSON()
		$.get
			url: "https://script.google.com/a/teamt5.org/macros/s/AKfycbzn7LjNQ5YQR97mQERARgPmsA8n3U7EyrN63x1Adw/exec"
			data: data
			dataType: "JSON"
			success: (response) ->
				$(e.currentTarget).prop('disabled', true)
				$(e.currentTarget).addClass('success')
				$(e.currentTarget).text('Success')
			error: (response) ->
				$(e.currentTarget).addClass('error')
				$(e.currentTarget).text('Error')

	# threatvision-contact-us-form
	$("#threatvision-contact-us-form-submit").click (e) ->
		e.preventDefault();
		data = $("#threatvision-contact-us-form").serializeJSON()
		$.get
			url: "https://script.google.com/a/teamt5.org/macros/s/AKfycbw5tsN8yq4g5D5XCoIsn0DPold7kgpBbuDCXqVL/exec"
			data: data
			dataType: "JSON"
			success: (response) ->
				$(e.currentTarget).prop('disabled', true)
				$(e.currentTarget).addClass('success')
				$(e.currentTarget).text('Success')
			error: (response) ->
				$(e.currentTarget).addClass('error')
				$(e.currentTarget).text('Error')



	# position form
	$("#position-form-submit").click (e) ->
		e.preventDefault();
		data = $("#position-form").serializeJSON()
		$.get
			url: "https://script.google.com/a/teamt5.org/macros/s/AKfycbyhx4Py9s91JBYEEZiKVqf7fgbaq0ENK2hwRP_S/exec"
			data: data
			dataType: "JSON"
			success: (response) ->
				$(e.currentTarget).prop('disabled', true)
				$(e.currentTarget).addClass('success')
				$(e.currentTarget).text('Success')
			error: (response) ->
				$(e.currentTarget).addClass('error')
				$(e.currentTarget).text('Error')
