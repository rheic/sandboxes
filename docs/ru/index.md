---
title: Документация Rheic | Локальные sandbox для coding-агентов
description: Соберите и изучите локальные sandbox Rheic. Быстрый старт, руководства, статус платформ, CLI и границы безопасности.
hide:
  - navigation
  - toc
  - path
  - footer
---

<main class="rheic-home" markdown>

<section class="home-hero" aria-labelledby="home-title">
<div class="home-hero-copy" markdown>
<p class="home-eyebrow">Документация Rheic · Локальная разработка · Pre-alpha</p>

<h1 id="home-title">Локальная граница для coding-агентов.</h1>

<p class="home-lede">Собирайте и проверяйте Rheic на своей машине. Начните с точных требований, выберите руководство по задаче и посмотрите, что действительно проверено на каждой платформе.</p>

<div class="home-actions">
<a class="home-button" href="quickstart/">Начать с быстрого старта <span aria-hidden="true">↗</span></a>
<a class="home-button home-button-secondary" href="cli/">Открыть справочник CLI</a>
</div>

<label class="home-search-trigger" for="__search"><span>Поиск по документации</span><kbd>/</kbd></label>

<p class="home-footnote">Pre-alpha · ограниченная VM-проверка на macOS ARM64 · полная квалификация агентов и платформ ещё не завершена</p>
</div>

<div class="home-terminal" aria-label="Примеры локальных команд Rheic">
<div class="home-terminal-head"><span class="home-terminal-brand"><img src="../assets/rheic-shark.png" alt=""><strong>Локальная работа</strong></span><span class="home-terminal-lang">rsbx</span></div>
<div class="home-terminal-code" markdown>
```sh
rsbx --help
rsbx agents list

# Режим state-only не запускает VM
sandboxesd --state ~/.sandboxes \\
  --socket ~/.sandboxes/s.sock
```
</div>
<div class="home-terminal-foot">Режим state-only проверяет локальную control plane. Он не запускает VM и не подтверждает изоляцию.</div>
</div>
</section>

<section class="home-section" aria-labelledby="choose-title">
<div class="home-section-heading"><div><p class="home-kicker">Выберите точку входа</p><h2 id="choose-title">Что вы хотите сделать?</h2></div><p>Используйте руководство для своей задачи, затем проверьте требования и ограничения перед запуском команд.</p></div>
<div class="home-path-grid">
<a class="home-card" href="quickstart/"><span class="home-card-mark" aria-hidden="true">01</span><h3>Запустить control plane</h3><p>Соберите CLI и daemon, запустите режим state-only и изучите локальное состояние.</p><span class="home-card-link">Быстрый старт →</span></a>
<a class="home-card" href="workspaces/"><span class="home-card-mark" aria-hidden="true">02</span><h3>Подготовить workspace агента</h3><p>Разберитесь с путями workspace, файловыми операциями и lifecycle sandbox.</p><span class="home-card-link">Руководство workspace →</span></a>
<a class="home-card" href="networking/"><span class="home-card-mark" aria-hidden="true">03</span><h3>Изучить сетевые границы</h3><p>Посмотрите deny-default модель, опубликованные порты и непроверенные runtime-сценарии.</p><span class="home-card-link">Руководство по сети →</span></a>
</div>
</section>

<section class="home-section" aria-labelledby="journey-title">
<div class="home-section-heading"><div><p class="home-kicker">Путь разработчика</p><h2 id="journey-title">От checkout до ограниченного workflow</h2></div><p>Настраивайте новую машину по порядку. Каждый шаг ведёт к требованиям и ограничениям, необходимым для решения.</p></div>
<div class="home-journey">
<article class="journey-step"><span class="journey-index">01 · Подготовка</span><h3>Проверьте платформу</h3><p>Изучите поддержку host, toolchain и runtime-компоненты.</p><a href="requirements/">Системные требования →</a></article>
<article class="journey-step"><span class="journey-index">02 · Запуск</span><h3>Запустите control plane</h3><p>Соберите совместимые бинарники и проверьте state-only режим.</p><a href="quickstart/">Быстрый старт →</a></article>
<article class="journey-step"><span class="journey-index">03 · Настройка</span><h3>Подключите workflow</h3><p>Изучите агентов, файлы, credentials и kits.</p><a href="agents/">Руководство по агентам →</a></article>
<article class="journey-step"><span class="journey-index">04 · Проверка</span><h3>Оцените границу</h3><p>Отличайте успех команды от VM- и security-проверки.</p><a href="security/">Модель безопасности →</a></article>
</div>
</section>

<section class="home-section" aria-labelledby="status-title">
<div class="home-status">
<div class="home-status-copy"><p class="home-kicker">Текущее состояние проекта</p><h2 id="status-title">Поддерживаемый путь зависит от host.</h2><p>Ограниченная VM-backed CLI acceptance прошла на macOS с Apple silicon. Linux KVM не квалифицирован; Windows WHP не интегрирован в production daemon. Опциональный guest Docker daemon запускается, но вложенные workload-команды пока заблокированы. Полная acceptance агентов, TTY и релиза остаётся открытой.</p></div>
<ul class="home-status-list" aria-label="Статус возможностей">
<li><span class="status-dot" aria-hidden="true"></span><span>Локальная control plane<strong>Доступна для разработки</strong></span></li>
<li><span class="status-dot status-dot-warn" aria-hidden="true"></span><span>VM-путь macOS ARM64<strong>Только ограниченная acceptance</strong></span></li>
<li><span class="status-dot status-dot-off" aria-hidden="true"></span><span>Квалификация Linux и Windows<strong>Не завершена</strong></span></li>
<li><span class="status-dot status-dot-off" aria-hidden="true"></span><span>Вложенные Docker workloads<strong>Заблокированы</strong></span></li>
</ul>
</div>
</section>

<section class="home-section" aria-labelledby="topics-title">
<div class="home-section-heading"><div><p class="home-kicker">Структура документации</p><h2 id="topics-title">Найдите нужную тему</h2></div><p>Английские и русские руководства повторяют одинаковую структуру. Переключите язык в шапке страницы.</p></div>
<div class="home-directory">
<div class="directory-group"><h3>Сборка и настройка</h3><div class="directory-links"><a href="agents/">Агенты</a><a href="workspaces/">Workspace и файлы</a><a href="networking/">Сеть и порты</a><a href="credentials/">Credentials и вход</a><a href="kits/">Kits</a></div></div>
<div class="directory-group"><h3>Запуск и обслуживание</h3><div class="directory-links"><a href="docker/">Docker</a><a href="tui/">Терминальная панель</a><a href="troubleshooting/">Решение проблем</a><a href="settings/">Настройки</a></div></div>
<div class="directory-group"><h3>Устройство системы</h3><div class="directory-links"><a href="architecture/">Архитектура</a><a href="security/">Модель безопасности</a><a href="requirements/">Системные требования</a></div></div>
<div class="directory-group"><h3>Справочник команд</h3><div class="directory-links"><a href="cli/">CLI</a><a href="quickstart/">Быстрый старт</a></div></div>
</div>
</section>

<section class="home-section" aria-labelledby="faq-title">
<div class="home-section-heading"><div><p class="home-kicker">Перед началом</p><h2 id="faq-title">Частые вопросы</h2></div><a href="faq/">Все ответы →</a></div>
<div class="home-faq">
<details><summary>Быстрый старт запускает VM?</summary><p>Нет. Он запускает daemon в режиме state-only, чтобы проверить локальную control plane. Для VM нужны дополнительные платформенные компоненты из раздела <a href="requirements/">Системные требования</a>.</p></details>
<details><summary>Можно ли запустить coding-агента внутри sandbox?</summary><p>CLI и runtime содержат agent и exec-пути, а ограниченная VM-backed lifecycle acceptance прошла на macOS ARM64. Полная интерактивная работа каждого агента и платформы не прошла acceptance. Смотрите <a href="agents/">руководство по агентам</a> и <a href="requirements/">статус платформ</a>.</p></details>
<details><summary>Успешная команда подтверждает изоляцию?</summary><p>Нет. Ответ CLI подтверждает только результат указанной команды. Для VM-изоляции нужны отдельные live runtime и security evidence. См. <a href="security/">модель безопасности</a>.</p></details>
<details><summary>Готов ли Docker Engine внутри guest к запуску workloads?</summary><p>Опциональный guest Docker daemon запускается, но вложенные <code>docker run</code>, <code>docker load</code>, <code>docker build</code> и Compose блокируются ограничениями guest <code>unshare</code> в текущем runtime. См. <a href="docker/">Docker и Rheic</a>.</p></details>
</div>
</section>

<section class="home-section" aria-label="Продолжить чтение">
<div class="home-endcap"><div><h2>Начните с вашей машины.</h2><p>Проверьте требования и пройдите state-only быстрый старт.</p></div><a class="home-button" href="requirements/">Системные требования ↗</a></div>
</section>

</main>
