require "spec_helper"

describe "checkins" do
  it "routes to #index" do
    expect(:get => "/checkins").to route_to(controller:"checkins", action:"index")
  end

  it "should routes to #create" do
    post("/checkins").should route_to("checkins#create")
  end
end

describe "root" do
  it "should routes to home#index" do
    get("/").should route_to("home#index")
  end
end

describe "devise" do
  it "should routes to devise#session#create" do
    post("/users/sign_in").should route_to("devise/sessions#create")
  end

  it "should routes to new" do
    get("/users/sign_in").should route_to("devise/sessions#new")
  end

  it "should routes to destroy" do
    delete("/users/sign_out").should route_to("devise/sessions#destroy")
  end

  it "should routes to password create" do
    post("/users/password").should route_to("devise/passwords#create")
  end

  it "should routes to password new" do
    get("/users/password/new").should route_to("devise/passwords#new")
  end

  it "should routes to password edit" do
    get("/users/password/edit").should route_to("devise/passwords#edit")
  end

  it "should routes to password update" do
    put("/users/password").should route_to("devise/passwords#update")
  end

  it "should routes to register cancel" do
    get("/users/cancel").should route_to("devise/registrations#cancel")
  end

  it "should routes to register create" do
    post("/users").should route_to("devise/registrations#create")
  end

  it "should routes to register new" do
    get("/users/sign_up").should route_to("devise/registrations#new")
  end

  it "should routes to register edit" do
    get("/users/edit").should route_to("devise/registrations#edit")
  end
  
  it "should routes to register update" do
    put("/users").should route_to("devise/registrations#update")
  end

  it "should routes to register destroy" do
    delete("/users").should route_to("devise/registrations#destroy")
  end
end

describe "users" do
  it "should routes to profile" do
    get("/profile").should route_to("users#profile")
  end

  it "should routes to update" do
    put("/profile").should route_to("users#update")
  end
end

describe "checkins" do
  it "should routes to index" do
    get("/checkins").should route_to("checkins#index")
  end
  
  it "should routes to create" do
    post("/checkins").should route_to("checkins#create")
  end
end

describe "management/checkins" do
  it "should routes to index" do
    get("/projects/1/checkins").should route_to("management/checkins#index", project_id:"1")
  end

  it "should routes to update" do
    put("/projects/2/checkins/3").should route_to("management/checkins#update", project_id:"2", id:"3")
  end
end

describe "membership" do
  it "should routes to destroy" do
    delete("/projects/2/memberships").should route_to("memberships#destroy", project_id:"2")
  end
end

describe "invitations" do
  it "should routes to create " do
    post("/projects/2/invitations").should route_to("invitations#create", project_id:"2")
  end

  it "should routes to update" do
    put("/projects/1/invitations/2").should route_to("invitations#update", project_id:"1", id:"2")
  end
end

describe "project" do
  it "should routes to show " do
    get("/projects/1").should route_to("projects#show", id:"1")
  end

  it "should routes to new" do
    get("/projects/new").should route_to("projects#new")
  end

  it "should routes to create" do
    post("/projects").should route_to("projects#create")
  end
end
