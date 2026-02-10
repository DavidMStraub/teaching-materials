# Public Slides

This repository contains slides of courses I teach. They are written in Markdown and rendered with [Marp](https://marp.app/). You can either directly look at the Markdown files rendered on Github or at the slides deployed to Github pages by going to https://davidstraub.de/public-slides.

Courses are organized in subfolders with individual index pages. Interactive courses include Binder buttons for running code directly in your browser.

See the [blog post](https://davidstraub.de/posts/my-new-presentation-slide-setup/) for details about my presentation slide setup.

## Running slides with code blocks in Jupyter 

### Local setup

Slides containing Python code blocks can be run interactively in Jupyter notebooks using Jupytext.

First, install the Jupytext Python package:

```bash
pip install jupytext
```

Then, open Jupyter Notebook or JupyterLab in the folder where you cloned the repository content and right-click on the desired Markdown file. Select "Open With" -> "Jupytext Notebook". This will open the slides as a Jupyter notebook where you can run and modify the code blocks interactively.

### Binder

For courses with interactive content, click the "🚀 Open in Binder" button on the course page. This launches a pre-configured Jupyter environment in your browser where you can run the code without any local setup.


## Credits

I'm using images licensed under creative commons licenses by directly linking to them.

- Lots of images are linked from [Wikimedia Commons](https://commons.wikimedia.org/wiki/Main_Page)
- Some images are linked from [Physik Libre](https://physikbuch.schule/), a free physics text book in German, which I can highly recommend!

## AI usage

Some parts of the content were generated or improved with the help of AI tools, primarily Github Copilot using Claude Sonnet 4.0 and 4.5. I have reviewed and edited all AI-generated content to ensure accuracy and quality and take full responsibility for the final content.