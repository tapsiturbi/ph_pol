module ApplicationHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def title(page_title, options={class: "page_title"})
    content_for(:title, page_title.to_s)
    #return content_tag(:h1, page_title.to_s, options)
    return ""
  end

  # copied from http://www.emersonlackey.com/article/rails3-error-messages-for-replacement
  def errors_for(object, message=nil)
    html = ""
    unless object.errors.blank?
      html << "<div class='formErrors #{object.class.name.humanize.downcase}Errors'>\n"
      if message.blank?
        if object.new_record?
          html << "\t\t<h5>There was a problem creating the #{object.class.name.humanize.downcase}</h5>\n"
        else
          html << "\t\t<h5>There was a problem updating the #{object.class.name.humanize.downcase}</h5>\n"
        end
      else
        html << "<h5>#{message}</h5>"
      end
      html << "\t\t<ul>\n"
      object.errors.full_messages.each do |error|
        html << "\t\t\t<li>#{error}</li>\n"
      end
      html << "\t\t</ul>\n"
      html << "\t</div>\n"
    end
    html
  end

  # Returns the hash filtered either by length or until it hits the target key
  def hash_until(hash, max_len=nil, target=nil)
    #(max_len > 0 ? Hash[Array(hash)[0..max_len-1]] : hash)

    if !target.nil? && hash.has_key?(target)
      return Hash[ Array(hash).take_while { |pair| pair[0] != target } ].merge( Hash[target, hash[target]] )

    elsif !max_len.nil?
      return Hash[Array(hash)[0..max_len-1]]

    else
      return hash
    end
  end

  def is_score_too_low(comment)
    if comment.cached_votes_score <= -3
      return true
    end

    return false
  end

  # Performs a HTTP GET to the specified URL. Returns a hash containing the following
  # info:
  # { images: all_imgs, title: subject, desc: og_desc, link: url }
  def http_get_og_data (url)
    http = Curl.get(url)
    html = http.body_str

    # Find all images and put them in list, put og:image meta first if it exists
    og_image = html.scan(/<meta\s+property=['"]?og:image['"]?[^>]*content=['"]?([^'"]*)/).flatten.first

    all_imgs = html.scan(/<img src=['"]([^'"]*)/).flatten.uniq
    if !og_image.empty?
      all_imgs.unshift(og_image)
    end

    # Find subject/title
    subject = html.scan(/<title[^>]*>([^<]*)<\/title>/).flatten.first

    # Description
    og_desc = html.scan(/<meta\s+property=['"]?og:description['"]?.*content=['"]?([^'"]*)/).flatten.first

    return { images: all_imgs, title: subject, desc: og_desc, link: url }
  end

  def trunc (str, maxlen)
    if str.length <= maxlen
      return str
    end

    return str[0..maxlen-3] + "..."
  end
end
