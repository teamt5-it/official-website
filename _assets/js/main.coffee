
//=require 'vendor/jquery'
//=require 'vendor/jquery.serializejson.js'
//=require 'vendor/autoresize.jquery.js'

desktop = ->
	return window.matchMedia('(min-width: 768px)').matches

$ ->
	$(".scroll-up").click ->
		window.scrollTo {top: 0, behavior: 'smooth'}

	$(".scroll-down").click ->
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


	# form
	$('textarea').autoResize();
	$("#contact-us-form-submit").click (e) ->
		e.preventDefault();
		data = $("#contact-us-form").serializeJSON()
		console.log(data)
		$.get
			url: "https://script.google.com/macros/s/AKfycbx533dQP94GOW3F0S2K3GEGStL-Vzr8bwFM1VQyAR4tnmHBg_Py/exec"
			data: data
			dataType: "JSON"
			success: (response) ->
				console.log(response)
				alert('succeed')
