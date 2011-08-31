---
layout: default
---

## Mappings/Inputs available

SimpleForm comes with a lot of default mappings:

  Mapping               Input                   Column Type

  boolean               check box               boolean
  string                text field              string
  email                 email field             string with name matching "email"
  url                   url field               string with name matching "url"
  tel                   tel field               string with name matching "phone"
  password              password field          string with name matching "password"
  search                search                  -
  text                  text area               text
  file                  file field              string, responding to file methods
  hidden                hidden field            -
  integer               number field            integer
  float                 number field            float
  decimal               number field            decimal
  datetime              datetime select         datetime/timestamp
  date                  date select             date
  time                  time select             time
  select                collection select       belongs_to/has_many/has_and_belongs_to_many associations
  radio                 collection radio        belongs_to
  check_boxes           collection check box    has_many/has_and_belongs_to_many associations
  country               country select          string with name matching "country"
  time_zone             time zone select        string with name matching "time_zone"
