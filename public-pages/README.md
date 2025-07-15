The purpose of this project is to display a richly formated reference of the eksctl cluster config file schema.

View schema: https://schema.eksctl.io/

The schema.js file loads the schema json directly from the main github repo.

https://raw.githubusercontent.com/eksctl-io/eksctl/refs/heads/main/pkg/apis/eksctl.io/v1alpha5/assets/schema.json

The schema.js file then renders a HTML table of the schema.

Index.html is just the page formatting around the table.

This is hosted with github pages, no build, just the main branch to github.io

This page will be referenced from the main AWS docs.
