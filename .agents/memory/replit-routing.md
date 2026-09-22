---
name: Artifact routing
description: Routing constraint when importing a full-stack app into the workspace artifact system
---

When an imported full-stack app serves both its UI and API from one process, keep the workspace's default API scaffold off the app's `/api` prefix so the root web artifact receives those requests.

**Why:** The proxy chooses the most-specific artifact path. A default API artifact on `/api` can intercept the imported app's requests and return gateway errors even while the imported server is healthy.

**How to apply:** Before validating an imported app, inspect registered artifact paths and move any unused scaffold route aside through the artifact manifest validation flow.