local schemas = {
  ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
  ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
    "docker-compose.yml",
    "docker-compose.yaml",
    "docker-compose.*.yml",
    "docker-compose.*.yaml",
  },
}

return {
	settings = {
    yaml = {
      schemas = schemas,
    },
  },
}
