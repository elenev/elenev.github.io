# Academic Personal Website

This README contains a brief description of my website for anyone who may want to use it as a template for their own. In creating this website, my goal was to create a simple, clean, and professional website, which is easy to maintain. Given that both the website and my PDF CV contain some of the same information, I wanted to make it easy to update both simultaneously.

## Tools

- **[Quarto](https://quarto.org)**: I used Quarto because it allows me to write in markdown, interweave code output, and contains pretty tempates. If you use VS Code, you can install the Quarto extension for a better experience, e.g., to preview the website without using the command line.
- **[Julia](https://julialang.org)**: I used Julia to process the data (stored in YAML format) and generate markdown content. Quarto also works with R, Python, and ObservableJS, all of which should be capable of parsing YAML into dictionaries and then looping over the data to generate content. I used Julia because it's my favorite language -- it's fast, elegant, and has an excellent dependency management system.
- **[Typst](https://github.com/typst/typst)**: I used Typst to create a PDF version of my CV from the same YAML-formatted data as the website. Typst is a modern alternative to LaTeX with much faster compile times, clean syntax, and a powerful and fairly intuitive programming language for creating templates.
Note: Typst has an excellent [Overleaf-style web app](https://typst.app/) with a live preview, autocomplete, syntax highlighting, and nice error messages. But it's hard to integrate a web app into a GitHub Pages workflow, so I use the CLI (command-line interface) in the production environment. I did my original development in the web app, so if you want to do extensive customizations, I suggest you sign up for an account and use the web app too.

## Quick Start

1. Install Quarto 1.5 or later, a recent version of Julia (use `juliaup` to make your life easier), and the Typst CLI.
2. Clone the repository. Set up your own local and remote on Github. Delete my `CNAME` file to avoid conflicts with your own custom domain.
3. Edit the `cv/cv.yml` file to include your own information. If you use VS Code with the `yaml-language-server` extension, the provided `cv/cv.json` schema will help with autocompletion.
4. Edit the top of the `index.qmd` file to include your own name, photo, social media links, and other info. Save any additional files (e.g. photo) in the `resources` folder.
5. Edit `_quarto.yml` to customize the navigation bar links, Twitter card, Google Analytics, etc.
6. Run `typst compile cv/main.typ` to generate a PDF version of your CV. Once you're happy with the result, move the PDF to `resources/cv.pdf`.
7. Run `quarto preview` or use the GUI interface in VS Code to generate the website and make sure everything looks right.
8. Run `quarto publish gh-pages` to publish the site to GitHub Pages. This will create/update a separate branch called `gh-pages` in your repository. You can configure `Pages` settings to serve the website from that repository. This keeps your `main` branch clean from the generated files.

## Customization

- You can change the order of sections in the website CV by editing `CV.qmd`. 
- You can change the order of sections in the PDF CV by editing `cv/main.typ`. 
- You can change the scheme, colors, and other styling by editing `styles.css`, `_quarto.yml`, and `theme-dark.scss`.
- If you want to fine-tune the display of generated content and don't want to learn Julia, you should be able to use generative AI (e.g., ChatGPT, GitHub Copilot) to translate my Julia code into the Quarto-compatible language of your choice, e.g., Python. The loops in `index.qmd` and `CV.qmd` are fairly simple and should be easy to translate. The code to parse the YAML data and print publications, etc. is in `common.jl` and is a bit more involved.
