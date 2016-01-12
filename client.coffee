Db = require 'db'
Dom = require 'dom'
Modal = require 'modal'
Obs = require 'obs'
Plugin = require 'plugin'
Page = require 'page'
Server = require 'server'
Ui = require 'ui'
Photoview = require 'photoview'

maps = Obs.create
	konigsleiten:
		button: 'Konigsleiten'
		image: 'konigsleiten.jpg'
	wildkogel:
		button: 'Wildkogel'
		image: 'arenaWildkogel.jpg'
currentPage = Obs.create ''

exports.render = !->
	# Determine page
	Obs.observe !->
		newCurrentPage = Page.state.get(0)
		area = maps.ref(newCurrentPage)
		maps.iterate (candidate) !->
			area = candidate if !area.peek()?
		currentPage.set area.key()

	Dom.div !->
		Dom.style
			position: 'absolute'
			top: '0'
			right: '0'
			left: '0'
		renderButtons()
	Dom.div !->
		renderPages()

renderButtons = !->
	Dom.div !->
		Dom.style
			Box: 'horizontal center'
			margin: '0 -1px 0 -1px'
		Dom.css '.areaButton.tap':
			background: 'linear-gradient(to bottom, #4fa7ff 0%,#0277ed 100%) !important'
		# Render buttons
		renderButton = (area) !->
			Dom.div !->
				Dom.cls 'areaButton'
				Dom.style
					Flex: true
					textAlign: 'center'
					height: '50px'
					lineHeight: '50px'
					background: 'linear-gradient(to bottom, #7abcff 0%,#4096ee 100%)'
					color: '#FFFFFF'
					borderRight: '1px solid #FFFFFF'
					borderLeft: '1px solid #FFFFFF'
				if currentPage.get() is area.key()
					Dom.style background: 'linear-gradient(to bottom, #4fa7ff 0%,#0277ed 100%)'
				Dom.text area.get('button')
				Dom.onTap !->
					currentPage.set area.key()
		maps.iterate (area) !->
			renderButton area

renderPages = !->
	maps.iterate (area) !->
		Dom.div !->
			Dom.style
				position: 'absolute'
				top: '50px'
				right: '0'
				bottom: '0'
				left: '0'
			Obs.observe !->
				if currentPage.get() is area.key()
					Dom.style display: 'bhack'
				else
					Dom.style display: 'none'
			Obs.observe !->
				height = Page.height()-200
				Photoview.render
					url: Plugin.resourceUri(area.get('image'))
					fullHeight: true
					height: height