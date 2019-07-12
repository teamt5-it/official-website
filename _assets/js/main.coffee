
//=require 'vendor/jquery'
//=require 'vendor/jquery.serializejson.js'
//=require 'vendor/autoresize.jquery.js'

desktop = ->
	return window.matchMedia('(min-width: 768px)').matches

$ ->
	$(".scroll-top").click ->
		window.scrollTo {top: 0, behavior: 'smooth'}

	$(".scroll-bottom").click ->
		window.scrollTo {top: $(".products").offset().top, behavior: 'smooth'}


	$(".navbar-brand").click ->
		$(".navbar-menu").toggleClass('active')
		$(".navbar-burger").toggleClass('active')

	$(".navbar-item-has-submenu").click (e) ->
		cur_navbar_submenu_active = $(e.currentTarget).children(".navbar-submenu").hasClass('active')
		cur_navbar_submenu_padding_active = $(".navbar-submenu-padding").hasClass('active')
		if !cur_navbar_submenu_active
			$(".navbar-submenu").removeClass('active')
			$(".navbar-item-arrow").removeClass('active')

		$(e.currentTarget).find(".navbar-item-arrow").toggleClass('active')
		$(e.currentTarget).children(".navbar-submenu").toggleClass('active')

		if (cur_navbar_submenu_active && cur_navbar_submenu_padding_active) || (!cur_navbar_submenu_active && !cur_navbar_submenu_padding_active)
			$(".navbar-submenu-padding").toggleClass('active')

	# carousel
	class Carousel
		duration = 200
		timer_duration = 5000
		constructor: () ->
			@count = $(".carousel .carousel-items").data('count')
			@cur_active_index = 0
			@register_event_handler()
			@start_timer()

		get_item: (index) ->
			$(".carousel .carousel-items .carousel-item[data-index=#{index}]")

		get_item_title_container: (index) ->
			$(".carousel .carousel-items .carousel-item[data-index=#{index}] .carousel-item-information-container")

		get_item_title: (index) ->
			$(".carousel .carousel-items .carousel-item[data-index=#{index}] .carousel-item-information-container .carousel-item-information")

		get_item_indicator: (index) ->
			$(".carousel .carousel-indicators .carousel-indicator[data-index=#{index}]")

		register_event_handler: () ->
			$(".carousel .carousel-indicators .carousel-indicator").click (e) =>
				index = $(e.currentTarget).data('index')
				@reset_timer()
				@set_active_item index

		start_timer: () ->
			@timer = setInterval =>
				@set_active_item (@cur_active_index+1)%@count
			, timer_duration

		reset_timer: () ->
			clearInterval(@timer)
			@start_timer()

		slide_item_left_and_disappear: (index) ->
			@get_item(index).addClass('left')
			new Promise((resolve)=>
				setTimeout =>
					@get_item(index).removeClass('active')
					@get_item(index).removeClass('left')
					resolve
				, duration
			)
		slide_item_right_and_disappear: (index) ->
			@get_item(index).addClass('right')
			new Promise((resolve)=>
				setTimeout =>
					@get_item(index).removeClass('active')
					@get_item(index).removeClass('right')
					resolve
				, duration
			)
		slide_item_from_right_to_center: (index) ->
			@get_item(index).addClass('right active')
			@get_item_title_container(index).addClass('left')
			@get_item_title(index).addClass('bottom')
			new Promise((resolve)=>
				setTimeout =>
					@get_item(index).addClass('center')
				, 0
				setTimeout =>
					@get_item(index).removeClass('right')
					@get_item(index).removeClass('center')
					@get_item_title_container(index).addClass('center')
				, duration
				setTimeout =>
					@get_item_title_container(index).removeClass('left')
					@get_item_title_container(index).removeClass('center')
					@get_item_title(index).addClass('center')
				, duration*2
				setTimeout =>
					@get_item_title(index).removeClass('bottom')
					@get_item_title(index).removeClass('center')
					resolve
				, duration*3
			)
		slide_item_from_left_to_center: (index) ->
			@get_item(index).addClass('left active')
			@get_item_title_container(index).addClass('left')
			@get_item_title(index).addClass('bottom')
			new Promise((resolve)=>
				setTimeout =>
					@get_item(index).addClass('center')
				, 0
				setTimeout =>
					@get_item(index).removeClass('left')
					@get_item(index).removeClass('center')
					@get_item_title_container(index).addClass('center')
				, duration
				setTimeout =>
					@get_item_title_container(index).removeClass('left')
					@get_item_title_container(index).removeClass('center')
					@get_item_title(index).addClass('center')
				, duration*2
				setTimeout =>
					@get_item_title(index).removeClass('bottom')
					@get_item_title(index).removeClass('center')
					resolve
				, duration*3
			)

		set_active_item: (index) ->
			@get_item_indicator(@cur_active_index).removeClass('active')
			@get_item_indicator(index).addClass('active')
			if @cur_active_index==index
				return
			else if @cur_active_index < index
				# coffeescript gem doesn't support await
				Promise.all([@slide_item_left_and_disappear @cur_active_index, @slide_item_from_right_to_center index])
			else
				Promise.all([@slide_item_right_and_disappear @cur_active_index, @slide_item_from_left_to_center index])
			@cur_active_index = index
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
