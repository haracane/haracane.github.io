require_relative "../domains/tag_link"
require_relative "../domains/tag_page"

Domains::TagPage.build_all
Domains::TagLink.build_all
