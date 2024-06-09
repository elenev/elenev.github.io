using CSV

indent_width = "    "

function csv_to_yaml(csvpath::String)
    df = CSV.read(csvpath, DataFrame)
    outstr = "presentations:\n"

    papers = unique(df.Paper)
    for p in papers
        outstr *= indent_width * "- paper: $p\n"
        outstr *= indent_width * "  talks:\n"
        paper_df = filter(row -> row.Paper == p, df)
        paper_df = select(paper_df, Not(:Paper))
        for t in eachrow(paper_df)
            outstr *= indent_width^2 * "  - venue: $(t.Venue)\n"
            outstr *= indent_width^2 * "    location: $(t.Location)\n"
            outstr *= indent_width^2 * "    type: $(t.Type)\n"
            outstr *= indent_width^2 * "    date: $(t.Date)\n"
            if t.Coauthor
                outstr *= indent_width^2 * "    coauthor: $(t.Coauthor)\n"
            end
        end
    end

    f = open("presentations.yaml", "w")
    write(f, outstr)
    close(f)
end

function discussion_csv_to_yaml(df)
    outstr = "discussions:\n"
    df = unstack(df[!,[:match,:group,:content]], :group, :content)
    for d in eachrow(df)
        (_, title, authors, venue, location) = d
        outstr *= indent_width * "- title: $title\n"
        outstr *= indent_width * "  authors: $authors\n"
        outstr *= indent_width * "  venue: $venue\n"
        outstr *= indent_width * "  location: $location\n"
        outstr *= indent_width * "  date: \"\"\n"
    end

    f = open("discussions.yaml", "w")
    write(f, outstr)
    close(f)
end