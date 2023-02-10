json.categories do
  json.array! @system_requirement, :id, :name, :operational_system, :processor
end