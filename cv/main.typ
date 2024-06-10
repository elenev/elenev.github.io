#let cvdata = yaml("cv.yml")
#let personal = cvdata.identity

#set page(
  "us-letter", 
  margin: (left: 1in, right: 1in, top: 1in, bottom: 1in),
  header: context 
    if here().page() == 1 {
    } else {
    grid(
      columns: (2fr, 2fr),
      rows: auto,
      align: (left, right),
      [#personal.name],
      [#counter(page).display("1",both: false)]
    )
  }
)
#set text(font: "EB Garamond", size: 11pt)
#show link: underline

#show heading.where(
  level: 1
): it => [
  #set align(center)
  #set text(26pt, weight: "semibold")
  #block(smallcaps(it.body))
]

#show heading.where(
  level: 2
): it => [
  #set text(11pt, weight: "regular")
  #block(smallcaps(it.body))
]

#let toplevel_block(header, contents) = {
  block(
    grid(
      columns: (16%, 1fr),
      gutter: 12pt,
      [== #header],
      [#contents]
    ),
    spacing: 20pt
  )
}

#let jobtitle(title) = [- #title]

#let nonblank(dict, field) = {
  field in dict.keys() and dict.at(field) != ""
}

#let employer_block(institution, location, positions) = {
  grid(
      columns: (60%, 1fr),
      rows: auto,
      gutter: 6pt,
      align: (left, right),
      [#institution],
        [#location],
      ..for (title, dates) in positions {
        (jobtitle(title), dates)
      }
    )
}

#let my_paper(d) = {
  block([
    *#d.title* \
    #d.coauthors
    #if nonblank(d,"journal") [
      \
      _#d.journal _
      #if nonblank(d,"biblio") [
        , #d.biblio
      ]
    ]
  ])
}

#let remove_repeated_dates(entries, datefield: "year") = {
  let sort_by(x) = x.at(datefield)
  entries = entries.sorted(key: sort_by).rev()
   let current_year = 0
   for (i,entry) in entries.enumerate() {
     if entry.at(datefield) == current_year {
       // do not print the year
       entries.at(i).at(datefield) = ""
     }
     current_year = entry.at(datefield)
   }
   entries
}

#let grant_text(grant) = [
  #grant.name
  #if "amount" in grant.keys() and grant.amount != "" [ (#grant.amount)]
  #if "corecipients" in grant.keys() and grant.corecipients != "" [
    \ 
    #h(1em) with #grant.corecipients
  ]
  \ 
]

#let grants_block(grants) = {
  grid(
    columns: (80%, 1fr),
    rows: auto,
    gutter: 6pt,
    align: (left, right),
    ..for (..other, year) in grants {
      (grant_text(other), year)
    }
  )
}

#let teaching_block(d) = {
  [
    #grid(
      columns: (80%, 1fr),
      rows: auto,
      gutter: 6pt,
      align: (left, right),
      [#d.institution],
        [#d.dates],
      ..for (title, role, level) in d.courses {
        ([ - #title (*#role*, #level)], "")
      }
    )
  ]
}

#let presentations_block(paper_title, presentations) = block[
  *#paper_title*
  #grid(
    columns: (70%, 15%, 1fr),
    rows: auto,
    gutter: 6pt,
    align: (left, left, right),
    ..for p in presentations {
      let descr = ""
      if nonblank(p,"coauthor") {descr = descr + "*"}
      descr = descr + p.venue + ", " + p.location
      (descr, p.type, p.date)
    }
  )
]

#let unbreaking(..args) = args.pos().map(grid.cell.with(breakable: false))

#let discussions_block(discussions) = {
  set grid.cell(breakable: false)
  grid(
      columns: (80%, 1fr),
      rows: auto,
      gutter: 10pt,
      align: (left, right),
      ..for d in discussions {
        let dstr = [#d.title, by #d.authors\
                _#d.venue, #d.location _]
        (dstr, d.date)
      }
    )
  }

#let service_block(type, entries) = block[
  #type \
  _#entries.join("; ")_
]

#let advising_block(header, advisees) = [
  *#header*:
  #grid(
    columns: (85%, 1fr),
    rows: auto,
    gutter: 10pt,
    align: (left, right),
    ..for a in advisees {
      let astr = [
        #a.name, "#a.title" \
        #h(1em) Placement: #a.placement.role, #a.placement.institution, #a.placement.location
      ]
      (astr, a.date)
    }
  )
]

#let two_column_block(array_of_dicts, sep: " ") = grid(
  columns: (80%, 1fr),
  rows: auto,
  gutter: 6pt,
  align: (left, right),
  ..for d in array_of_dicts {
      let v = d.values()
      let date = v.pop()
      (v.join(sep), date)
  }
)

// Name

= #personal.name

#line(length: 100%)

// Contact Info
#grid(
  columns: (60%, 1fr),
  
  [#personal.address.join("\n") \
   #personal.phone \
   #link("mailto:" + personal.email) ],

  align(right)[
    
    #link(personal.website) \
    #for (url, network) in personal.profiles [
      #link(url)[#network] \
    ]
  ]
)

// Academic Positions

#toplevel_block("Academic Positions", 
  for (institution, location, positions) in cvdata.academic-positions {
    employer_block(institution, location, positions)
  }
)

#toplevel_block("Education",   
  for (institution, location, degrees) in cvdata.education {
    employer_block(institution, location, degrees)
  })

#toplevel_block("Research Interests", [Macro Finance: financial intermediation, monetary policy, real estate])

#toplevel_block("Peer-Reviewed Publications", 
for p in cvdata.publications {
  my_paper(p)
}
)

#toplevel_block("Working Papers", for p in cvdata.working-papers {
  if nonblank(p,"status") {p.journal = p.status}
  my_paper(p)
})

#toplevel_block("Works in Progress", for p in cvdata.works-in-progress {
  my_paper(p)
})

#toplevel_block("Grants", grants_block(remove_repeated_dates(cvdata.grants))
)

#toplevel_block("Awards, Honors, and Fellowships", 
for g in cvdata.awards {
  grant_text(g)
}
)

#toplevel_block("Teaching Experience", 
for t in cvdata.teaching {
  teaching_block(t)
}
)

#toplevel_block("Presentations", [
  Including scheduled. Conference presentations by co-authors marked with a \*.

  #for p in cvdata.presentations {
    presentations_block(p.paper, p.talks)
  }
])

#toplevel_block("Conference Discussions", 
  discussions_block(remove_repeated_dates(cvdata.discussions, datefield: "date"))
)

#toplevel_block("Professional Service", 
for s in cvdata.professional-service {
  service_block(s.title, s.items)
}
)

#toplevel_block("Doctoral Advising",
for d in cvdata.advising {
  advising_block(d.institution, 
      remove_repeated_dates(d.advisees, datefield: "date"))
}
)

#toplevel_block("University Service",[
  #two_column_block(cvdata.university-service)
])

#toplevel_block("Memberships",[
  #cvdata.memberships.join(", ")
])

#toplevel_block("Other Employment",[
  #two_column_block(cvdata.other-employment, sep: ", ")
])

#toplevel_block("Personal",cvdata.personal.join("\n"))