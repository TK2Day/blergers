require 'pry'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require "blergers/version"
require 'blergers/init_db'
require 'blergers/importer'

module Blergers
  class Post < ActiveRecord::Base
    has_many :post_tags
    has_many :tags, through: :post_tags


    def self.page(n)
     Blergers::Post.order(date: :desc).limit(10).offset((n - 1) * 10)

    end
  end

  class Tag < ActiveRecord::Base
    has_many :post_tags
    has_many :posts, through: :post_tags

   def self.top_tags
     #how brit did it
     #Blergers::Tag.all.map {|x| [x.name, x.posts.count] }.sort_by {|x| x|1|}.reverse
     #maybe? I cant tell im blindlol

     #Howdidbritdothis.jpg

     #Blergers::Tags.joins(:post_tags).
     #group_by {|x| x.name}.
     #map {|k, v| [k, v.length}.
     #sort_by {|x| x|1| }.
     #reverse
     Tag.joins(:post_tags).group(:name).count

     
   end


  end

  class PostTag < ActiveRecord::Base
    belongs_to :post
    belongs_to :tag
  end
end

def add_post!(post)
  puts "Importing post: #{post[:title]}"

  tag_models = post[:tags].map do |t|
    Blergers::Tag.find_or_create_by(name: t)
  end
  post[:tags] = tag_models

  post_model = Blergers::Post.create(post)
  puts "New post! #{post_model}"
end

def run!
  blog_path = '/Users/brit/projects/improvedmeans'
  toy = Blergers::Importer.new(blog_path)
  toy.import
  toy.posts.each do |post|
    add_post!(post)
  end
end

binding.pry
