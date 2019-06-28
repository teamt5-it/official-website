
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


	# contact-us-form
	$('textarea').autoResize();
	$("#contact-us-form-submit").click (e) ->
		e.preventDefault();
		data = $("#contact-us-form").serializeJSON()
		$.get
			url: "https://script.google.com/macros/s/AKfycbx533dQP94GOW3F0S2K3GEGStL-Vzr8bwFM1VQyAR4tnmHBg_Py/exec"
			data: data
			dataType: "JSON"
			success: (response) ->
				$(e.currentTarget).prop('disabled', true)
				$(e.currentTarget).addClass('success')
				$(e.currentTarget).text('Success')
			error: (response) ->
				$(e.currentTarget).addClass('error')
				$(e.currentTarget).text('Error')


	# form
	$("#position-form-submit").click (e) ->
		e.preventDefault();
		data = $("#position-form").serializeJSON()
		$.get
			url: "https://script.google.com/macros/s/AKfycbxzOuA3U8N30yy711X_4th_2ty4WqBiepxjcPAauda1hp3cM9I/exec"
			data: data
			dataType: "JSON"
			success: (response) ->
				$(e.currentTarget).prop('disabled', true)
				$(e.currentTarget).addClass('success')
				$(e.currentTarget).text('Success')
			error: (response) ->
				$(e.currentTarget).addClass('error')
				$(e.currentTarget).text('Error')
