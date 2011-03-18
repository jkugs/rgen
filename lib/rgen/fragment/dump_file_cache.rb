module RGen

module Fragment

# Caches model fragments in Ruby dump files.
#
# Dump files are created per each fragment file.
#
# The main goal is to support fast loading and joining of fragments. Therefore the cache 
# stores additional information which makes the joining process faster (adding to 
# environment, resolving references)
#
class DumpFileCache

  # +cache_map+ must be an object responding to +load_data+ and +store_data+
  # for loading or storing data associated with a file;
  # this can be an instance of Util::FileCacheMap
  def initialize(cache_map)
    @cache_map = cache_map 
  end

  # Note that the fragment must not be connected to other fragments by resolved references
  # unresolve the fragment if necessary
  def store(fragment)
    @cache_map.store_data(fragment.location,
      Marshal.dump({
        :root_elements => fragment.root_elements,
        :elements => fragment.elements,
        :index => fragment.index,
        :unresolved_refs => fragment.unresolved_refs,
        :data => fragment.data
      }))
  end

  def load(fragment)
    dump = @cache_map.load_data(fragment.location)
    return :invalid if dump == :invalid
    header = Marshal.load(dump)
    fragment.set_root_elements(header[:root_elements],
      :elements => header[:elements],
      :index => header[:index],
      :unresolved_refs => header[:unresolved_refs])
    fragment.data = header[:data]
  end

end

end

end


