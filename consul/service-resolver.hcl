Kind          = "service-resolver"
Name          = "http"
DefaultSubset = "blue"
Subsets = {
  "blue" = {
    Filter = "ServiceTags[0] == blue"
  }
  "green" = {
    Filter = "ServiceTags[0] == green"
  }
}
