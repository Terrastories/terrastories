Flipper.register(:developers) do |actor|
  actor.respond_to?(:developers_group?) && actor.developers_group?
end
