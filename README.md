# SuperResources

SuperResources DRYs up your controller code by abstracting your controller's strandard RESTful actions and by providing 
standard helpers to access the controller's target resource(s) in a consistent way across all controllers. More than that,
SuperResources exploits the application's routes to provide simplified path helpers for nested resources.

With SuperResources, in the great majority of common REST situations, you can use the same resource helpers and path helpers, 
regardless of the the specific type of resource or how it is nested, even if the resource is nested under many other resources.

## Installation

Add this line to your application's Gemfile:

    gem 'super_resources'

And then execute:

    bundle install

Or install it yourself as:

    gem install super_resources

## Usage

To gain all the standard RESTful actions, just `include SuperResources::Controller` in your controller:

    class OrganizationUnitsController < ApplicationController
      include SuperResources::Controller
    end

### Resource Helper Methods

SuperResources provides helper methods that you can use directly in the controller, views or helper methods:

    resource
    collection

For member actions, `resource` answers a single object that the RESTFUL is operating on.
For collection actions (i.e `index1), `collection` answer a scoped collection of objects.

SuperResources does away with specifically named instance variables, such as those created by standard scaffolds. For example, in the example above, SuperResources does not give you `@organization_unit` or `@organization_units` for free. You won't need them in the common cases. Using `resource` and `collection` in every controller makes for easier coding and maintenance.

### Path Helper Methods

SuperResources provides a set of vastly simplified path helpers.

    collection_path #=> path to the resource's index action
    resource_path(object = resource)
    new_resource_path
    edit_resource_path(object = resource)

Note that the helper methods that require an input argument, assumes the current resource by default, so you don't have to pass it in.

#### These Helper Methods Work Even When the Resource is Nested

Because SuperResources uses the metadata created by your routes declarations to work out whether the resource has been nested and if so, automatically uses the nesting objects to build complete paths. This relieves you of passing in an array to the path helper.

With this feature alone, SuperResources cleans up your code and makes it more reusable. For example, the same code can be used when you 
have a resource that is nested inside multiple other objects. SuperResources dynamically works out the nesting that applies in each case.

## Nested Resource

Let's face it: deailing with nested resources has always been a pain. All that fiddling about, getting the path names and inputs right. Chane the nesting and you have to go through and chaneg all your path calls too. Then, if you have a resource that can be nested within multiple other resources, such as when you have an associative object and you want to navigate to it from any of it associations, the permutations become very complex.

It should be much easier, especially when you take routes into account. If I have an action that is matched to this route:

    /notes/:note_id/pages/:id

then shouldn't I have paths available that can work out the nesting context, so that I don't hard code it?

SuperResources does this. For example, including SuperResources in `PagesController` will allow me to simply call, 
for example, `edit_resource_path` and the code has been actioned through the above route, the nesting with a Note identified by `:note_id` will be assumed. Even better, if the same code is actioned by another route with different nesting, SuperResources will get that right too.

If you need, such as when you want to link 'outside the nest' as it were, you still have `note_page_path(note, page)` available to you.

### Parent Helper Method

Sometimes you want to use the object that is nesting your resource, such as when you want to customize a redirect. SuperResources provides 
`parent` to answer that object. For example given, the following route:

    /notes/:note_id/pages/:id


calling `parent` will answer a Note object with an id of `:note_id`. 

For deeper nests, the immediately nested object is always answered by `parent`. For example, given this route:

    /authors/:author_id/notes/:note_id/pages/:id

calling `parent` will still answer a Note object with an id of `:note_id`. 

### Accessing Route Objects

Any nested route implies a component hierarchy of objects. SuperResources allows you to access these objects bye a convenient name.

For example, given this route:

    /authors/:author_id/notes/:note_id/pages/:id

you can make these calls:

  author  #=> Author with an id of :author_id
  note    #=> Note with an id of :note_id
  page    #=> Page with an id of :id

An example of a place where you will want these, is in a layout template that presents information about the nesting objects. For example, you may want to show a page inside an author layout template. The author layout template will present information about the author. In this case, the layout will be used in the context of `PagesController`, so you can't refer to `resource` in the layout, since it will answer the page, not the author. You need some way to arbitrarily refer to the author.  Being able to call `author` provides this.

## Adapting and Customising

### Resource Class

SuperResources derives the class of the target resource from the controller name. For example, `OrganizationUnitsController` operates, by default, on resources of the class `OrganizationUnit`. If you want to change this, redefine hotspot method `resource_class`, for example:

    class TeamsController < ApplicationController
      include SuperResources::Controller

      protected

      def resource_class
        OrganizationUnit
      end
    end

### Resource Helper Methods

Yes, you can adapt these to suit your needs. 

Both `resource` and `collection` accept a block, which SuperResources uses to stitch into its internal implementation, so tht any subsequent calls to these helpers uses your implementation.
The block for `resource` shall answer a single instance of the resource class and the block for `collection` shall answer an array of instances of the resource class. 

For example, if you wanted 'TeamsController#collection' to return only those teams that the current user has joined, you would write an implementation of `collection` that calls its super, passing a block the evalautes to the right collection:

    def collection
      super { resource_class.joined_by(current_user) }
    end

If that looks strange, bear in mind it's been designed so that you don't need to know how SuperResources internally uses your preferred implementation.

### Finder Method

Before being able to use the result of `resource`, SuperResources may need to find it. The canonical way to do this is to do:

  resource_class.find(:params[:id])

While SuperResource uses the `find` method as the default, you can choose another finder method by redefining `finder_method`. For example:

    class PagesController < ApplicationController

      protected

      def finder_method
        :find_by_position
      end
    end

### Builder Method

SuperResources extracts the construction of a new resource into the `build_resource` method. If you need to create a new resource, say in a special action, use 'build_resource' so that SuperResource can also keep track of it (for example, make sure that `resource' answers the built object).

If you need to do specialized work for the build, pass the a block to `build_resource` that evaluates to an object with the state you need. For example:

    build_resource do
      resource_class.new do |p|
        # initialize the state here
      end
    end

More commonly, you would redefine the whole method so that it always behaves the same way for its enclosing controller:

    def build_resource
      super do
        resource_class.new do |p|
          # initialize the state here
        end
      end
    end

### Redefining Actions

Yes, you can. All actions defined by SuperResources use responders and accept parameters to pass to `respond_with`, so customizing these parameters is a common adaptation.

For example, suppose that after creating a comment, you want to redirect to an index of comments that apply to the same parent. Adapt teh action like this:

    def create
      super :location => polymorphic_url([ parent, :comments ])
    end

Anything you can pass to `respond_with`, you can pass to he super call, including a block.

You could, of course, completely redefine an action:

    def new
      # knock yourself out
    end

### Defining Actions

Just do it. Declare them in your controller and match them in routes. All the SuperResources helpers are still available to you.

## Acknowledgments

SuperResources would never have happened without InheritedResources [https://github.com/josevalim/inherited_resources] existing first.
We preferred the idea of abstracting and extracting RESTful actions out of all our controllers and we're not so keen on scaffolds generating
un-DRY code. We used InheritedResources in a production deployed application [meetlinkshare.com], gained some experience and decided we wanted an even DRYer tool.

The basic mechanics of SuperResources was hacked out during Rails Camp 12 in Tasmania, Australia and was subsequently applied to MeetLinkShare.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
