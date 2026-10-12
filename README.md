# Modern Web Development Lab (2h) – React, Next.js, Server Actions vs REST

## 0. Overview

This lab recaps web basics and introduces students to **modern web development** through:

- A short theoretical introduction:
  - From classic multi-page websites to React-based apps
  - React fundamentals: components, declarative UI, virtual DOM
  - Next.js fundamentals: routing, server vs client components, server actions
  - REST APIs vs server actions (and where each shines)

- A hands-on lab with **Next.js**:
  - A **simple website** with some simple **components**
  - A **client-side component** that calls a **public REST API** to display a “message of the day”
  - A simple **in-memory Todo app**
  - Using **server actions** for creating/updating/deleting todos

The aim is **exposure**, not mastery: students will follow guided steps, see real-world patterns, and get a feel for modern tools.

---

## 1. Learning Goals

By the end of the lab, students should:

- Understand at a high level:
  - How React differs from “classic” DOM manipulation
  - How Next.js sits on top of React and adds server-side capabilities
  - The difference between **REST APIs** and **server actions**
  - Meet Tailwinds and other libraries along the way
- Be able to:
  - Run a modern Next.js app in a Docker container
  - Modify a simple React component tree
  - Use a **server action** to mutate data on the server
  - Use `fetch()` in a **client component** to call a public REST API

---

## 2. Suggested Time Plan (2h)

- **0–30 min** – Theoretical introduction
- **30–40 min** – Environment and project setup
- **40–70 min** – Project overview, basic website and components, REST API calls
- **70–110 min** – Implementing the Todo app with server actions
- **110–120 min** – Wrap-up, discussion, Q&A

---

## 3. Theory Intro (30 min) – Talking Points

### 3.1 Web Basics

- Client-server model
- Layered overview: MAC (Network Access), IP (Internet), TLS (Transport), DNS/HTTP/etc. (Application)
- Multi-tenancy, virtualization
- Scalability, orchestration
- Security, WAF, cloud WAF

---

### 3.2 Classic Web vs Modern Web

- **Classic model:**
  - Server generates HTML (e.g., PHP, JSP, ASP.NET).
  - Browser displays static HTML.
  - Each interaction → new page load.
- **SPA model (focus on UX):**
  - Browser runs a **JavaScript application**.
  - Server provides **data** (often JSON) via APIs.
  - UI updates dynamically without full page reloads.
- **Modern model (speed, UX, and focus on DX):**
  - Browser runs a **hybrid application**.
  - Part of the site is statically generated (SSG), part is rendered on the server (SSR), and part is rendered on the client (CSR).
  - This combines all approaches and their benefits (speed, interactivity) under one umbrella enhancing the DX (JS everywhere, fast Node server, advanced Next features).

Key ideas:

- HTML + CSS + JS + HTTP still form the base.
- The **DOM (Document Object Model)** is the in-memory tree of elements.
- JS can manipulate the DOM, but doing this manually at scale is hard → _enter React_.

Development:

- You understand the underlying concepts and architectural approaches
- You conceptualize the product, define features, limitations, technology selection, and security boundaries
- Code-completion models, LLMs, and agents do the heavy lifting with your approval
- You are responsible for formal verification, test definition, reviewing, and security

---

### 3.3 React Fundamentals

**Main idea:**

> React lets you build UI from reusable **components** and keep the UI in sync with **state** in a **declarative** way.

Explanation:

- **Declarative vs Imperative**
  - Imperative:  
    “Find this element, change its text, add/remove children…”
  - Declarative (React):  
    “Given this state, here’s how the UI should look”; React figures out DOM changes.
- **Components**
  - Small, reusable building blocks of UI.
  - Typically functions returning JSX:  
    `function Button() { return <button>Click</button>; }`
- **JSX**
  - Syntax extension that looks like HTML inside JS/TS.
  - Compiled to `React.createElement(...)`.
- **Props**
  - Inputs to components.  
    E.g. `<Button label="Save" />` → `label` is a prop.
- **State**
  - Data that can change over time.
  - `useState` hook allows components to store and update state.
- **Virtual DOM**
  - React builds a virtual representation of the DOM.
  - On state changes, it computes the difference and efficiently updates the real DOM.

---

### 3.4 Next.js Fundamentals

**React** is only the UI library (mostly client-side).  
**Next.js** is a **React framework** that adds:

- **File-based routing**
  - Files in `app/` (e.g. `app/page.tsx`, `app/todos/page.tsx`) correspond to routes (`/`, `/todos`).
- **Server-side rendering (SSR) & static generation**
  - Components can render on the server → send HTML to browser.
- **Server Components vs Client Components**
  - **Server components** (default in `app/`):
    - Run only on the server.
    - Can access databases, secrets, etc.
    - Not sent as JS to the client → smaller bundle.
  - **Client components**:
    - Marked with `"use client"` at the top.
    - Can use hooks (`useState`, `useEffect`), handle events, etc.
- **Data fetching on the server**
  - Server components can `await` data directly.
- **Server Actions**
  - Functions that run on the server, but can be called from components/forms.
  - They can modify data and then re-render pages.

> **Key message:** Next.js lets you choose **where** code runs (server vs client) and gives you tools (server actions, routing, data fetching) to implement modern full-stack apps.

---

### 3.5 REST API vs Server Actions

Explain both as ways to talk to server logic:

- **REST API:**
  - You expose HTTP endpoints (e.g. `GET /api/todos`, `POST /api/todos`).
  - Clients (browser, mobile app, other services) send requests and get JSON.
  - Independent of the frontend framework.
  - Good when **many different clients** need the same API.

- **Server Actions:**
  - Special **server-side functions** you can call from forms or client components.
  - No need to manually write API routes and `fetch` for simple UI operations.
  - Great for **internal app logic** (e.g. “add todo for this user”).

For students:

> REST is like a public phone line anyone can call.  
> Server actions are like private intercom buttons wired directly into your app.

---

### 3.6 CI/CD (Very Brief)

- **Git** as the collaboration backbone.
- **CI/CD pipeline**:
  - On push: install dependencies, run tests, build.
  - If successful: deploy to production.
- Examples: GitHub Actions, GitLab CI, etc.

---

## 4. Lab Environment Setup with Docker

> Note: Make use of VSCode Extensions, such as Prettier to auto-format the code, SonarLint to highlight it, GitLens to help you view commit graph, Emmet and various snippets, etc.

Goal: Students can run everything with **Docker + VS Code**, regardless of OS.

1. Use **Docker Compose** to start a container with Node.
2. Mount the project directory into the container.
3. Run `npm install` and `npm run dev` _inside the container_, but code is edited from the host via VS Code.

### 4.1 Folder Structure (target)

We aim for something like:

```text
modern-web-lab/
  README.md
  docker-compose.yml
  next-site/
    app/
      page.tsx
      podstran/
        page.tsx
    public/
      image.png
    next.config.mjs
    package.json
    tsconfig.json
    ...
```

---

### 4.2 `docker-compose.yml`

Examine the `docker-compose.yml`.

- The file creates a new Linux container from Node.js 20 image.
- Mounts the directory `./next-site` into `/usr/src/app` inside the container.
- Exposes port 3000 in the container (Next.js dev server) to port 3000 on your computer.
- The container then either autostart the development Next.js webserver or waits for you to create a new project (if starting it for the first time).

---

### 4.3 Starting the container

1. Use Terminal of CMD to navigate to the current project folder (e.g., `cd C:\Users\LTFE\Desktop\modern-web-lab`).
2. Start the Docker service on your computer (e.g., Start Menu > Docker)
3. Run `docker compose -f docker-compose.dev.yml up` in the Terminal/CMD

If you are starting the container for the first time (Next.js is not installed yet) the container will silently wait. If you are restarting the container and have already started the development the container will automatically install the required dependencies and run the development web server.

---

## 5. Creating the Next.js Project

### 5.1 Scaffold (Install Next.js and create a new project)

First, let's check if the container is running using `docker ps`.

Then, enter the container using `docker exec -it modern-web-lab-dev sh`.

Now, from inside the Docker container run:

```bash
npx create-next-app@latest .

# Answer prompts (accept the default suggestions ...)
```

This will create a Next.js app using the `app/` directory and TypeScript.

---

### 5.2 Start the Dev Server

Once the project is created stop the container (use `Ctrl+C` in the first Terminal) and then restart it:

```bash
docker compose -f docker-compose.dev.yml up
```

- This will run `npm install` and then `npm run dev`.

Then, open the browser at `http://localhost:3000`. You should see the default Next.js starter page.

---

## 6. Simple Website using Next.js

> Note: You can install React Dev Tools in Chrome to help you with debugging.

- Directory structure and app router
  - Layout
  - Homepage
  - Subpages

- Page structure
  - Notice the JSX/TSX
  - Everything is a component
  - Server components by default

- Create simple website
  - Replace homepage content
  - Create a subpage
  - Link pages together
  - Style elements
  - Use Tailwinds CSS

- Create your reusable components
  - Make a button
  - Make it use props

- What do you notice in regard to website refreshing?
  - Explain using layout.tsx
  - Are the pages SSR or CSR?

## 7. REACTivity (React Hooks), API Calls / Server Actions

- Hooks
  - Demonstrate useState with inputs
  - Demonstrate useEffect with inputs

- REST APIs
  - Fetch quote(s) from `https://motivational-spark-api.vercel.app/api/quotes/random(/N)`
  - Turn it into a component

- Client Side vs. Server Side
  - Simple password login
  - API Call vs. Server Action

- ShadCN
  - Make it beautiful

- Deploy to prod
  - Move password to .env

- Vibe code

## 8. Quick Command Cheatsheet

> Note: You can also use the `make` command with the supplied `Makefile` on POSIX systems.

```bash
# Start the dev environment
docker compose -f docker-compose.dev.yml up

# (If needed) open a shell inside the container
docker compose exec web sh

# Once inside the container, you can run:
npm install
npm run dev

# For production builds you can use
npm run build
npm run start

# Or rely on a production grade docker-compose
docker compose -f docker-compose.prod.yml build
docker compose -f docker-compose.prod.yml up

```

In browser:

- Visit `http://localhost:3000` to see the app.

---

## 9. Modern Web Tech Stacks and Overview

| **Category**                                             | **What it means (for students)**                                                                                                                               | **Examples of Technologies**                                                                                                                                                                                                                                                                                                      |
| -------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Programming Languages**                                | These describe _how we write programs_. Some are used in the browser (JavaScript/TypeScript), others are used to build backends, servers, tools, and runtimes. | **JavaScript** — language of the browser<br>**TypeScript** — JavaScript with types<br>**Zig\*\*** — low-level systems language<br>**Rust** — safe systems language (used in SWC, Turbopack)<br>**Go** — backend & tooling language<br>**Python** — general‑purpose scripting                                                      |
| **JavaScript / Web Runtimes**                            | Programs that **run JavaScript outside the browser**, powering servers, tools, and CLIs — sometimes with built‑in bundlers and APIs.                           | **Node.js** — standard JS runtime<br>**Bun** — fast Node‑compatible runtime built in Zig<br>**Deno** — secure runtime from the creator of Node<br>**Cloudflare Workers Runtime** — edge runtime<br>**Vercel Edge Runtime** — lightweight edge JS                                                                                  |
| **Package Managers**                                     | Tools that download, install, and manage external libraries and dependencies for projects.                                                                     | **npm** — default Node package manager<br>**pnpm** — efficient & fast alternative<br>**Yarn** — Node package manager<br>**Deno.land/x** — Deno’s module registry<br>**Bun PM** — built‑in Bun package manager                                                                                                                     |
| **Build / Dev Tools (Bundlers, Compilers, Dev Servers)** | Tools that turn developer‑friendly code (modules, JSX, TS) into **optimized browser‑ready JS/CSS/HTML**, usually with hot reload during development.           | **Vite** — modern fast dev server + bundler<br>**Webpack** — highly configurable bundler<br>**Rollup** — bundler for libraries & ES modules<br>**Parcel** — zero‑config bundler<br>**SWC** — ultra‑fast JS/TS compiler (Rust)<br>**esbuild** — very fast bundler (Go)<br>**Turbopack** — Next.js Rust‑based bundler (in progress) |
| **UI Libraries / Frontend Frameworks**                   | Help build **interactive user interfaces** using reusable components instead of manually manipulating the DOM.                                                 | **React** — component UI library<br>**Vue.js** — progressive UI framework<br>**Svelte** — compiler‑based UI framework<br>**SolidJS** — fine‑grained reactive UI library<br>**Preact** — lightweight React alternative                                                                                                             |
| **Full‑Stack / Meta‑Frameworks**                         | Frameworks that **add routing, SSR, APIs, data‑loading and deployment support on top of UI frameworks** — used for real production apps.                       | **Next.js** — full‑stack React framework<br>**Nuxt.js** — full‑stack Vue framework<br>**SvelteKit** — full‑stack Svelte framework<br>**Remix** — server‑centric React framework<br>**Astro** — content‑driven meta‑framework<br>**RedwoodJS** — full‑stack React + GraphQL framework                                              |
| **Backend Web Frameworks**                               | Frameworks used to **build APIs and backend services** — usually running on Node.js, Bun, or Deno.                                                             | **Express.js** — minimal Node web framework<br>**Fastify** — fast modern Node framework<br>**NestJS** — structured backend framework (Node)<br>**Hono** — tiny fast framework (Node/Bun/Deno/Edge)<br>**Koa** — lightweight middleware framework                                                                                  |
| **Databases & Persistence (for context)**                | Where applications store data long‑term — not JavaScript‑specific, but essential in real systems.                                                              | **PostgreSQL** — relational DB<br>**MySQL / MariaDB** — relational DBs<br>**MongoDB** — NoSQL DB<br>**SQLite** — file‑based DB<br>**Redis** — in‑memory store                                                                                                                                                                     |
| **Deployment & Hosting Platforms**                       | Services that run applications in production, sometimes with serverless or edge runtimes.                                                                      | **Vercel** — optimized for Next.js<br>**Netlify** — static + serverless hosting<br>**AWS** — cloud provider<br>**Azure** — Microsoft cloud<br>**Cloudflare** — edge compute + CDN                                                                                                                                                 |

---

### 📌 Key Student Takeaway

> **Languages** let us write programs.  
> **Runtimes** execute JavaScript outside the browser.  
> **Package managers** install and manage dependencies.  
> **Build tools** bundle, compile, and optimize code.  
> **UI libraries** help build interactive interfaces.  
> **Full‑stack frameworks** add routing, SSR, and server logic.  
> **Backend frameworks** power APIs and server apps.  
> **Databases** persist data.  
> **Hosting platforms** run everything in production.
