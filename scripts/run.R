library(botor)

run <- toupper(Sys.getenv("RUN"))
from_path <- Sys.getenv("FROM")
to_path <- Sys.getenv("TO")
text <- Sys.getenv("TEXT")
write_outpath <- Sys.getenv("OUTPATH")

if (run == "COPY") {
  if (from_path == "" | to_path == "") {
    stop(
      paste0(
        "Missing FROM and/or TO env vars. Got FROM => ",
        from_path,
        ". TO => ",
        to_path,
        "."
      )
    )
  }
  s3_copy(from_path, to_path)
} else if (run == "WRITE") {
  if (text == "" | write_outpath == "") {
    stop(
      paste0(
        "Missing TEXT and/or OUTPATH env vars. Got TEXT => ",
        text,
        ". OUTPATH => ",
        write_outpath,
        "}."
      )
    )
  }
  s3_write(text, write, write_outpath)
} else {
  stop(
    paste0(
      "Bad RUN env var. Got ", run, ". Expected 'copy' or 'write'."
    )
  )
}
