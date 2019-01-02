# usho
Elixir/Phoenix/Redis URL shortener

A 2019 New Year present for the community!

# Concept

1. Use Redis as a data storage.
2. Use HashID on an integer counter, stored in Redis to generate URL signatures.
3. Phoenix as an http server.
4. Use the builtin Redis data expiration mech (EXPIRE).
5. RingLogger for the log's capturing.
6. Alchemetrics for the metrics.

# Specs refinements / constraints

1. JSON assumed to be an acceptable response format.
2. Swagger had been used for API documentation.
3. Hit's history is queable on per-signature basis.
4. System runs in dev environment by default. Update Dockerfile and rebuild the image to switch to prod mode.
5. Local hosts file modification required and is assumed acceptable.

# Tests

Unit-tests provided for crucial subsystems.
Swagger UI is available at http://usho:4000/api/swagger/index.html#/

# Last minute notes

Metrics and logging collection/pushing schemes are out of the task boundaries.

# Installation instructions

Add records to your hosts file:

a1.b1.c1.d1 usho

a2.b2.c2.d2 redis

which should point to your Phoenix and Redis instances respectively.

Then run:

mix deps.get

mix phx.server

# License
This solution for the abovementioned assignment is provided under the MIT license.
