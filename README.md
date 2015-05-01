# Preparam

*Validation by contract for rails parameters*

# Introduction




Every body seems to hate [rails/strong_parameters](https://github.com/rails/strong_parameters) for quite a few good reasons. I think a brief page of rails history need to be explained as to why it exists in the first place. Strong parameters was put in place to fix the problem of mass assignment. In previous versions of rails (< INSERT VERSION HERE), it was possible to set all attributes at once on a model. This seemed like a very convenient way to update a model attributes, however it is a double edged sword. Let's say we wanted to update our user model attributes in the edit profile page. We would have the following action :

```ruby
class UserController
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      render @user
    else
      render @user.errors, status: :unprocessable_entity
    end
  end
end
```

This is a fairly common rails idiom, and it's an interesting approach to update our model. However we can safetly assume that our model can contain attributes that we dont necessairly want to be updated. If we dig down into rails active_record source, we can predict that it's using `public_send(:attribute_name, new_value)` to our model, which assumes that the attribute has a public writer method defined. Let's assume that our user can be an admin if we set the attribute `admin = true`. In the previous version, the user class would look like the following.

```ruby
class User < ActiveRecord::Base
  attr_writer :username, :admin
end
```

``` ruby
# HTTP 1.1 PUT
user: { id: 1, password: 'my_new_password' }

# We changed the users password yay!
```

Strong parameters was put in place to for people to define what attributes are event allowed to be sent to the model. Let's take the previous example and and strong parameters to it.

```ruby
class UserController
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      render @user
    else
      render @user.errors, status: :unprocessable_entity
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :twitter_handle)
  end
end
```

What if we have a more complex schema of parameters that we would want to validate with certain conditions. Let's take a checkout model. A checkout has many things attached to it: customer billing address, shipping address, applied gift cards, discount codes, line items, etc. What if we wanted to require the gift card code only if the gift card array is supplied. This is currently impossible with strong parameters has it doesn't serve this purpose. The validation would have to be done manually and the attributes updated manually. What preparam aims to provide is a validation mechanism for the parameters provided and prevent mass assignment at the same time.

Here are some example as to how this complex schema could be solved with preparam.

```ruby
# defining the schema as a block
params.preparam do
  required :token, is_a: String

  optional :line_items, is_a: Array do
    required :variant_id, is_a: Integer
    required :quantity, is_a: Integer
    optional :properties, is_a: Hash
  end

  optional :gift_cards, is_a: Array do
    required :code, is_a: String
  end

  optional :discount, is_a: Hash do
    required :code, is_a: String
  end
end
```

```ruby
# defining a custom schema
class CheckoutSchema < Preparam::Schema
  required :token, is_a: String

  optional :line_items, is_a: Array do
    required :variant_id, is_a: Integer
    required :quantity, is_a: Integer
    optional :properties, is_a: Hash
  end

  optional :gift_cards, is_a: Array do
    required :code, is_a: String
  end

  optional :discount, is_a: Hash do
    required :code, is_a: String
  end
end

params.preparam_with CheckoutSchema.new
```

```ruby
# defining fragments
class CheckoutSchema < Preparam::Schema
  required :token
  use GiftCardsSchema
  use DiscountsSchema
  use LineItemsSchema
end
```

By default, when the parameters does not respond to the specified schema, errors are raised. If an ActiveModel
is passed, the errors are added to the model to the specified attribute if the models has it. It will raise a
Preparam::InvalidParameterError which can be catched by rails and render a :bad_request response.

# Installation

Brave enough to try it? Add the following in your `Gemfile`.

```
gem 'preparam', github: 'maximbedard/preparam'
```

# Usage

This is a WIP, not there yet.
