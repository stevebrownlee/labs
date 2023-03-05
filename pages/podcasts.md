---
layout: list
collection: "podcasts"
title: Podcasts
description: "A selection of our work and podcast."
permalink: "/podcasts/"
header_transparent: true

hero:
  enabled: true
  heading: "Podcasts"
  sub_heading: "Our portfolio of work and podcast."
  text_color: "#FFFFFF"
  background_color: "#2d2830"
  background_gradient: false
  background_image_blend_mode: "overlay" # "overlay", "multiply", "screen"
  background_image: "/assets/images/gen/podcasts/hero.png"
  fullscreen_mobile: false
  fullscreen_desktop: false
  height: "450px"
  buttons:
    enabled: false
    list:
      - text: "Contact Us"
        url: "/contact"
        external: false
        fa_icon: false
        size: large
        outline: true
        style: "light"

grid:
  collection: "podcasts"
  sort_by: "weight" # "date", "weight"
  columns: 2

intro:
  enabled: false
  align: left
  image: false
  heading: "We are a full service digital agency"
  sub_heading: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut eget sapien in elit semper accumsan. Pellentesque accumsan ut tortor eu varius. Sed id tincidunt massa, ut egestas orci."
  features:
    enabled: true
    list:
      - text: "Some of our podcast are open source"
        fa_icon: false
  buttons:
    enabled: true
    list:
      - text: "View Github"
        url: "https://github.com/zerostaticthemes"
        external: true
        fa_icon: "fab fa-github"
        size: "large"
        outline: false
        style: "primary"

outro:
  enabled: true
  align: left
  image: false
  heading: "Ready to get started?"
  sub_heading: "Contact us today for a free quote!"
  buttons:
    enabled: true
    list:
      - text: "Get A Quote"
        url: "/contact"
        external: false
        fa_icon: false
        size: "normal"
        outline: false
        style: "primary"
---
