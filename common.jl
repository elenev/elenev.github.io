using YAML
cvyaml = read("cv/cv.yml", String)
cvyaml = replace(cvyaml, "\t"=>" "^4) # YAML.jl can't handle tabs
cvdata = YAML.load(cvyaml);

notblank(d,k) = k ∈ keys(d) && d[k] != ""

function print_paper(paper, presentations, type; include_by_coauthor=false)
    println("::: {.callout-$type collapse=\"true\"}")
    print("## <span class=\"title-bold\">", paper["title"], "</span>")
    print("<br><span class=\"authors-normal\">", paper["coauthors"], "</span>")
    if notblank(paper,"journal")
        println("<br><span class=\"journal-italic\">", paper["journal"], "</span>")
    else
        println()
    end

    println("<p>")

    if notblank(paper,"urls")
        for u in paper["urls"]
            print(" [\\[", u["text"], "\\]](", u["href"], ")")
            println("")
        end
    end
    println("")
    
    if notblank(paper,"abstract")
        println(paper["abstract"])
    end
    this_presentations = filter(p -> p["paper"] == paper["title"], presentations)

    if this_presentations !== nothing && length(this_presentations) > 0
        this_presentations = this_presentations[]

        println("")
        println("*Presentations:*")
        println("")
        
        for pres in this_presentations["talks"]
           if include_by_coauthor || !notblank(pres,"coauthor") || !pres["coauthor"]
              if notblank(pres,"coauthor") && pres["coauthor"]
                coauthor_string = " (by coauthor)"
              else
                coauthor_string = ""
              end
              println(" - ", pres["venue"], ", ", pres["location"], ", ", pres["date"], coauthor_string)
           end
        end
        println("")
    end
    println("</p>\n:::")
    println("")
end;