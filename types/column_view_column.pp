type Foreman::Column_view_column = Struct[
  {
    title => String[1],
    after => String[1],
    content => String[1],
    Optional['conditional'] => String[1],
    Optional['eval_content'] => String[1],
    Optional['view'] => String[1],
    Optional['width'] => String[1],
    Optional['custom_method'] => String[1],
  }
]
