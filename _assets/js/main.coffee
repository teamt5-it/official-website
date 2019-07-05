
//=require 'vendor/jquery'
//=require 'vendor/jquery.serializejson.js'
//=require 'vendor/autoresize.jquery.js'

desktop = ->
	return window.matchMedia('(min-width: 768px)').matches

$ ->
	$(".scroll-top").click ->
		window.scrollTo {top: 0, behavior: 'smooth'}

	$(".scroll-bottom").click ->
		window.scrollTo {top: document.body.scrollHeight, behavior: 'smooth'}


	$(".navbar-brand").click ->
		$(".navbar-menu").toggleClass('active')
		$(".navbar-burger").toggleClass('active')

	$(".navbar-item").click (e) ->
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
	$(".carousel .carousel-items .carousel-item[data-index=1]").addClass('active')
	$(".carousel .carousel-indicators .carousel-indicator[data-index=1]").addClass('active')
	a = 1
	$(".carousel .carousel-items .carousel-item[data-index=#{a}]").addClass('left')
	$(".carousel .carousel-items .carousel-item[data-index=#{a}]").addClass('center')

	$('textarea').autoResize();

	# threat-sonar-contact-us-form
	$("#threat-sonar-contact-us-form-submit").click (e) ->
		e.preventDefault();
		data = $("#threat-sonar-contact-us-form").serializeJSON()
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

	# threat-vision-contact-us-form
	$("#threat-vision-contact-us-form-submit").click (e) ->
		e.preventDefault();
		data = $("#threat-vision-contact-us-form").serializeJSON()
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
