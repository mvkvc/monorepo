// https://developers.cloudflare.com/workers/examples/auth-with-headers/

export interface Env {
	AUTH_HEADER: string;
	AUTH_PSK: string;
}

const handler: ExportedHandler = {
	async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
		function hasValidHeader(request: Request, env: Env) {
			// Not sure how to show in <img> tag client side with auth header
			// return request.headers.get(env.AUTH_HEADER) === env.AUTH_PSK;
			return true
		};

		function authorizeRequest(request: Request, env: Env) {
			switch (request.method) {
				case 'GET':
					return hasValidHeader(request, env);
				default:
					return false;
			}
		}

		if (!authorizeRequest(request, env)) {
			return new Response('Forbidden', { status: 403 });
		} else {
			return fetch(request);
		}
	},
};

export default handler;
