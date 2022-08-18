module main

import vweb
import json

struct App {
	vweb.Context
}

const (
	port = 8102
)

struct AuthenticationResult {
	is_superadmin bool
	result        string
}

struct AuthenticationPayload {
	username string
	password string
}

fn main() {
	println('emqx.io HTTP authentication server starting...')

	vweb.run(&App{}, port)
}

pub fn (mut app App) index() vweb.Result {
	return app.text('Hello from vweb')
}

[post]
pub fn (mut app App) authenticate() vweb.Result {
	if app.req.data.len > 0 {
		data := json.decode(AuthenticationPayload, app.req.data) or {
			app.set_status(403, 'Forbidden')
			return app.json(AuthenticationResult{
				is_superadmin: false,
				result: 'deny',
			})
		}


		if data.username == 'alwin' && data.password == '123' {
			return app.json(AuthenticationResult{
				is_superadmin: false,
				result: 'allow',
			})
		}
	}

	res := AuthenticationResult{
		is_superadmin: false
		result: 'deny'
	}

	app.set_status(403, 'Forbidden')

	return app.json(res)
}
