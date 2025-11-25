# Routing philosophy

Use resource-oriented URLs.

Nest under the primary domain objects:

/care-circles/{circleId}/threads

/care-recipients/{id}/notes

Use plural nouns for collections.

IDs are always path params, filters are query params.

No verbs in paths except for clear actions (/ai/…, /auth/…).

ignore any of these instruction that contradic Expo routers way of doing things