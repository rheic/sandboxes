---
title: Rheic documentation | Local sandboxes for coding agents
description: Build and inspect local Rheic sandboxes. Find the quick start, task guides, platform status, CLI, and security boundaries.
hide:
  - navigation
  - toc
  - path
  - footer
---

<main class="rheic-home" markdown>

<section class="home-hero" aria-labelledby="home-title">
<div class="home-hero-copy" markdown>
<p class="home-eyebrow">Rheic docs · Local development · Pre-alpha</p>

<h1 id="home-title">A local boundary for coding agents.</h1>

<p class="home-lede">Build and inspect Rheic on your own machine. Start with the exact prerequisites, follow a task guide, and check what each platform has actually validated.</p>

<div class="home-actions">
<a class="home-button" href="quickstart/">Start with the quick start <span aria-hidden="true">↗</span></a>
<a class="home-button home-button-secondary" href="cli/">Browse the CLI reference</a>
</div>

<label class="home-search-trigger" for="__search"><span>Search the documentation</span><kbd>/</kbd></label>

<p class="home-footnote">Pre-alpha software · limited macOS ARM64 VM acceptance · full agent and platform qualification remain open</p>
</div>

<div class="home-terminal" aria-label="Rheic local command examples">
<div class="home-terminal-head"><span class="home-terminal-brand"><img src="assets/rheic-shark.png" alt=""><strong>Explore locally</strong></span><span class="home-terminal-lang">rsbx</span></div>
<div class="home-terminal-code" markdown>
```sh
rsbx --help
rsbx agents list

# State-only mode does not boot a VM
sandboxesd --state ~/.sandboxes \\
  --socket ~/.sandboxes/s.sock
```
</div>
<div class="home-terminal-foot">State-only mode checks the local control plane. It does not boot a VM or prove isolation.</div>
</div>
</section>

<section class="home-section" aria-labelledby="choose-title">
<div class="home-section-heading"><div><p class="home-kicker">Choose a starting point</p><h2 id="choose-title">What are you here to do?</h2></div><p>Use the guide for your task, then check its prerequisites and known limits before running commands.</p></div>
<div class="home-path-grid">
<a class="home-card" href="quickstart/"><span class="home-card-mark" aria-hidden="true">01</span><h3>Try the local control plane</h3><p>Build the CLI and daemon, start state-only mode, and inspect local state.</p><span class="home-card-link">Quick start →</span></a>
<a class="home-card" href="workspaces/"><span class="home-card-mark" aria-hidden="true">02</span><h3>Prepare an agent workspace</h3><p>Understand how workspace paths, file operations, and sandbox lifecycle fit together.</p><span class="home-card-link">Workspace guide →</span></a>
<a class="home-card" href="networking/"><span class="home-card-mark" aria-hidden="true">03</span><h3>Review network boundaries</h3><p>See the deny-default policy model, published ports, and what still needs runtime evidence.</p><span class="home-card-link">Network guide →</span></a>
</div>
</section>

<section class="home-section" aria-labelledby="journey-title">
<div class="home-section-heading"><div><p class="home-kicker">Developer journey</p><h2 id="journey-title">From checkout to a bounded workflow</h2></div><p>Move in order when setting up a new machine. Each step links to the details needed to make a decision.</p></div>
<div class="home-journey">
<article class="journey-step"><span class="journey-index">01 · Prepare</span><h3>Check your platform</h3><p>Review host support, toolchain, and runtime inputs.</p><a href="requirements/">System requirements →</a></article>
<article class="journey-step"><span class="journey-index">02 · Start</span><h3>Run the control plane</h3><p>Build compatible binaries and inspect state-only mode.</p><a href="quickstart/">Quick start →</a></article>
<article class="journey-step"><span class="journey-index">03 · Configure</span><h3>Connect the workflow</h3><p>Read about agents, files, credentials, and kits.</p><a href="agents/">Agent guide →</a></article>
<article class="journey-step"><span class="journey-index">04 · Verify</span><h3>Check the boundary</h3><p>Separate command success from VM and security acceptance.</p><a href="security/">Security model →</a></article>
</div>
</section>

<section class="home-section" aria-labelledby="status-title">
<div class="home-status">
<div class="home-status-copy"><p class="home-kicker">Current project status</p><h2 id="status-title">The supported path depends on the host.</h2><p>A limited VM-backed CLI lifecycle passed on macOS with Apple silicon. Linux KVM is not qualified; Windows WHP is not integrated into the production daemon. The opt-in guest Docker daemon starts, but nested workload commands remain blocked. Full agent, TTY, and release acceptance are still open.</p></div>
<ul class="home-status-list" aria-label="Capability status">
<li><span class="status-dot" aria-hidden="true"></span><span>Local control plane<strong>Available for development</strong></span></li>
<li><span class="status-dot status-dot-warn" aria-hidden="true"></span><span>macOS ARM64 VM path<strong>Limited acceptance only</strong></span></li>
<li><span class="status-dot status-dot-off" aria-hidden="true"></span><span>Linux and Windows qualification<strong>Open</strong></span></li>
<li><span class="status-dot status-dot-off" aria-hidden="true"></span><span>Nested Docker workloads<strong>Blocked</strong></span></li>
</ul>
</div>
</section>

<section class="home-section" aria-labelledby="topics-title">
<div class="home-section-heading"><div><p class="home-kicker">Documentation map</p><h2 id="topics-title">Find a topic</h2></div><p>English and Russian guides share the same sections. Use the language control in the header to switch.</p></div>
<div class="home-directory">
<div class="directory-group"><h3>Build and configure</h3><div class="directory-links"><a href="agents/">Agents</a><a href="workspaces/">Workspaces and files</a><a href="networking/">Network and ports</a><a href="credentials/">Credentials and sign-in</a><a href="kits/">Kits</a></div></div>
<div class="directory-group"><h3>Run and maintain</h3><div class="directory-links"><a href="docker/">Docker</a><a href="tui/">Terminal dashboard</a><a href="troubleshooting/">Troubleshooting</a><a href="settings/">Settings</a></div></div>
<div class="directory-group"><h3>Understand the system</h3><div class="directory-links"><a href="architecture/">Architecture</a><a href="security/">Security model</a><a href="requirements/">System requirements</a></div></div>
<div class="directory-group"><h3>Look up commands</h3><div class="directory-links"><a href="cli/">CLI reference</a><a href="quickstart/">Quick start</a></div></div>
</div>
</section>

<section class="home-section" aria-labelledby="faq-title">
<div class="home-section-heading"><div><p class="home-kicker">Before you begin</p><h2 id="faq-title">Common questions</h2></div><a href="faq/">Read all FAQs →</a></div>
<div class="home-faq">
<details><summary>Does the quick start launch a VM?</summary><p>No. It starts the daemon in state-only mode so you can inspect the local control plane. VM setup requires additional platform-specific components described in <a href="requirements/">System requirements</a>.</p></details>
<details><summary>Can I run a coding agent inside the sandbox?</summary><p>The CLI and runtime contain agent and exec paths, and limited VM-backed lifecycle acceptance passed on macOS ARM64. Full interactive workflows for every agent and platform have not passed acceptance. Check the <a href="agents/">agent guide</a> and <a href="requirements/">platform status</a>.</p></details>
<details><summary>Does a successful command prove isolation?</summary><p>No. A CLI response confirms only the operation reported by that command. VM isolation needs its own live runtime and security evidence. See the <a href="security/">security model</a>.</p></details>
<details><summary>Is Docker Engine inside the guest ready for workloads?</summary><p>The opt-in guest Docker daemon can start, but nested <code>docker run</code>, <code>docker load</code>, <code>docker build</code>, and Compose are blocked by guest <code>unshare</code> restrictions in the current runtime. See <a href="docker/">Docker and Rheic</a>.</p></details>
</div>
</section>

<section class="home-section" aria-label="Continue reading">
<div class="home-endcap"><div><h2>Start with the machine you have.</h2><p>Check the prerequisites, then follow the state-only quick start.</p></div><a class="home-button" href="requirements/">Review system requirements ↗</a></div>
</section>

</main>
