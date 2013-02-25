module Helpers
  module Lists
    def sort_list(list, &block)
      explicit, implicit = list.partition { |i| i[:sort_order] }
      (explicit.sort_by { |i| i[:sort_order] } + implicit.sort_by(&block))
    end

    def kluge_koepfe
      people = @items.find_all { |i| i.identifier =~ %r|^/assets/images/headshots/| and not i[:hide_in_menu] }
      sort_list(people) { |i| i[:name] }
    end

    def trainings
      trainings = @items.find_all { |i| i.identifier =~ %r|^/trainings/\d/| and not i[:forward] }
      sort_list(trainings) { |i| i[:title] }
    end

    def article_list
      articles = kluge_koepfe.find_all { |i| i[:articles] }
      sort_list(articles) { |i| i[:name] }
    end

    def book_list
      books = kluge_koepfe.find_all { |i| i[:books] }
      sort_list(books) { |i| i[:name] }
    end

    def open_source_list
      projects = kluge_koepfe.find_all { |i| i[:open_source] }
      sort_list(projects) { |i| i[:name] }
    end

    def advisory_board_list
      advisors = kluge_koepfe.find_all { |i| i.identifier =~ %r|^/assets/images/headshots/beirat/| }
      sort_list(advisors) { |i| i[:name] }
    end

    def trainer_list
      trainers = kluge_koepfe.find_all { |i| i.identifier =~ %r|^/assets/images/headshots/trainer/| }
      sort_list(trainers) { |i| i[:name] }
    end

    def training_grouped_by(metadata, value)
      trainings = @items.find_all do |i|
        i.identifier =~ %r|^/trainings/| and
                not i[:hide_in_menu] and
                i.attributes.fetch(:training, {}).fetch(metadata, {}).any? { |item| item == value }
      end

      sort_list(trainings) { |i| i[:title] }
    end

    def consulting_quotes_list
      quotes = @items.find_all { |i| i.identifier =~ %r|^/consulting/| and not i[:hide_in_menu] and i[:quotes] }
      sort_list(quotes) { |i| i[:title] }
    end

    def training_quotes_list
      quotes = @items.find_all { |i| i.identifier =~ %r|^/trainings/| and not i[:hide_in_menu] and i[:quotes] }
      sort_list(quotes) { |i| i[:title] }
    end

    def interviews_list
      interviews = @items.find_all { |i| i.identifier =~ %r#^/(consulting|trainings)/# and not i[:hide_in_menu] and i.attributes.fetch(:quotes, [{}]).any? { |item| item[:youtube] } }
      sort_list(interviews) { |i| i[:title] }
    end
  end
end
