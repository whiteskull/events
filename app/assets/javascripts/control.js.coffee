window.Control =

	# get cookie
	cookie: (cookie_name)->
		result = document.cookie.match ( '(^|;) ?' + cookie_name + '=([^;]*)(;|$)' )
		if result
			unescape ( result[2] )
		else
			''

	# set cookie
	cookie_set: (name, value, days = 30)->
		oDate = new Date()
		oDate.setDate(days + oDate.getDate())
		# domain = self.location.host
		document.cookie = name + "=" + value + "; path=/; expires=" + oDate.toGMTString()

	# delete cookie
	cookie_delete: (name)->
		# domain = self.location.host
		document.cookie = name + "=; path=/; expires=Thu, 01 Jan 1970 00:00:01 GMT"
