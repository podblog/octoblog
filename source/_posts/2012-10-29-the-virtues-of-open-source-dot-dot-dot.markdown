---
layout: post
title: "The virtues of open-source..."
date: 2012-10-29 13:12
comments: true
categories: [agalmic, open-source, photo, ]
sharing: true
---

{% img center https://s3.amazonaws.com/dvblog/ruby.png 679 410 'Coding' %}

Sorry about the dearth of updates over the past few days. The wedding edit took some time, as well as real-life things having to happen as well. And then Halloween. The biggest, most interesting challenge, however, was the selection and deployment of a web application to display the edited photos from Tal and Erick's wedding...

<!-- more -->

The edit itself went flawlessly. With my MacBook Air being a completely solid-state system, the actual rendering and editing took no time at all. Any time spent was purely on creative decisions. Protip - double-check that your sensor is clean. Cloudless blue skies make for wonderful wedding backdrops, but every little dust particle shows up. And the ultrasonic cleaner will not get them all. I spent a good amount of time spotting each photo. I usually check my sensor, but my MK II has the cleaning system, so I thought nothing of it. Wrong. Dust still adheres to the sensor surface. 

I teased the bride and groom with little Instagram previews of my progress. It was a photo of a photo, but they got a kick out of it. 

{% instagram 308863042945417370_31120127 %}

Finally, I completed the edit, and then had to tackle the task of how best to display the photos. 

Now, the obvious solution would have been to just use a canned solution like Flickr, or 500 px. While both services have their strong points, the fact that I don't have direct control over my content did give me cause for concern. Plus, with my recent forays into the world of building web applications and coding, I wanted to roll my own solution as much as possible. 

Initially, I wanted to present the site via Octopress. I have experience in Octopress now, because of this blog, and several photo display plugins have been written for the platform. 

I had done some research, and found that the web app <a href="http://fancyapps.com/fancybox">Fancybox</a> integrated somewhat smoothly with Octopress. Also, a fellow Octopress user, <a href="http://tritarget.org/blog/2012/05/07/integrating-photos-into-octopress-using-fancybox-and-plugin/">Tritarget</a> had written a pretty good plugin which made the display of photos even easier, since it utilized simple Markdown tags, rather than coding raw HTML. 

To make things easy, and not interfere with the operation of this blog, I chose to spin up another instance on my <a href="http://heroku.com/">Heroku</a> account. Heroku is the ideal choice for this and other projects of mine because I can spin up as many instances as I want, and only accrue charges for the total amount of resources (regardless of the number of apps) that I consume. After a little tweaking and adjustments, I got Fancybox and the plugin to play nice with Octopress. 

Fancybox is probably the best-looking HTML-based photo display app out there. Slick transitions, a great UI, and easy implementation (mostly), make for a great quick-and-dirty display solution. However, the downside is, there is no practical way, that I found, to do a "gallery". And a gallery was needed since my final edit came to 530 photos. 

{% img center https://s3.amazonaws.com/dvblog/preview_collage.jpg 960 960 'Previews' %}

And I certainly wasn't going to manually input the Markdown tags for 530 photos. So, with that in mind, I decided to divest my thoughts of using Octopress. I set out to find a dedicated photo display solution. Some enterprising individuals had written plugins which can read Flickr sets, but I didn't want to host on Flickr, for copyright and personal reasons. So, I googled around a bit and found several Rails-based photo gallery apps.

Now, some of you may ask, why wouldn't I just use the Rails-based photo gallery app that I had already, i.e. <a href="http://seenightlife.com/">See Nightlife</a>?

Well, to be honest, See Nightlife is broken. I can upload and display, but all organizational tools are offline. It's a "write once" solution as it stands. I can't even delete photos. Also, Ryan and I simply haven't had the time to fix it. Plus, the app it was based on, <a href="https://github.com/rapind/albumdy">Albumdy</a> is no longer being maintained. 

As this was to display the wedding photos of two of my closest friends, something a little more reliable needed to be found. These are wedding photos, not a bunch of images of kids blindly worshipping some guy playing music off of his Mac. 

So, with that in mind, I settled on a fairly popular Rails app called <a href="http://balderapp.com/">Balder.</a>

Developed and maintained by Espen Antonsen out of Norway, Balder is a currently-maintained-and-produced Rails app for displaying photos in a collection/album format. And it fit my use case perfectly, as I wanted to host my photos on S3, and have the app live on Heroku. Heroku is more for running applications, and not storage. S3 is eminently more suited to storage, hence "Simple Storage Service" (S3). Espen himself uses this setup, and even provided a howto guide <a href="http://blog.inspired.no/rails-photo-gallery-balder-on-heroku-and-s3-726/">on his blog</a> on how to do it. In a nutshell, you provide Balder your S3 key, secret, and bucket name in a config file, commit to Heroku, and go from there. The one stumbling block I encountered is that the uploader itself tries to call an EXIF display module, which is dependent on a UNIX executable, which to my knowledge, cannot be installed on Heroku. So, even though the initial deployment was fast, the actual implementation wasn't. 

Now, where the virtues of open source kick in is that I had the code for Balder on my local machine. Through Heroku's logging, I could see where the app was breaking uploads. I'm still a 'babe in the woods' when it comes to coding, but I can read what the code is doing. I saw where it was getting hung up, but had no idea on how to fix it, or comment it out, since I specifically didn't need EXIF data to be displayed. For those who may not be familiar, EXIF data is basically metadata contained in a JPEG file, which shows things like the camera type, exposure settings, and so on. You can see the EXIF data of a photo by doing the "File Info" function on your operating system of choice. 

{% img center https://s3.amazonaws.com/dvblog/exif.png 964 541 'Coding' %}

So, via the <a href="https://github.com/espen/balder">issues tracker in the Github repository for Balder</a>, I submitted a request for support from the developer. Now, since the app is free, and Espen derives no income from it, he was under zero obligation to respond to me. Since it was the weekend, I didn't expect much right away. But, by this morning, he had filed a response to my request:

{% blockquote Espen Antonsen https://github.com/espen/balder/issues/36 HTML5 Uploader Generates HTTP Error %}

Try commenting out "before_create :exif_read" in the photo model. I will look into this later but currently too busy with other work.

{% endblockquote %}

I appreciated his honesty, that's for sure. Way more than I expected. Most free open-source projects are one-shot deals where the developer does the initial work, and then forgets about it. So, I was pleasantly surprised at a reply. 

And fortunately, his solution worked. I commented out a call to the non-existent EXIF module, and successfully uploaded some photos as a test. After confidently seeing that they displayed and cycled according to my wishes, I then began to upload the wedding photos in earnest. Balder has an excellent organizational structure. I can create a collection, let's call it "Wedding", and then albums for each portion of the event. Very slick. Five stars. And wonderful support from someone whom isn't even obligated to do so. 

Now, if this was a closed-source solution or a problem with a hosted service like Flickr, I would have had no way of figuring out what was wrong. I would have had to email their support, wait, and hope they could get to the issue in time. With open-source, I can peek under the hood, make some educated assessments as to what the issue is, and attempt a fix on my own. Or at the least, get concrete info that the developer understands so he or she can make a more effective fix. Plus, I got to learn a little more about just what makes a Rails-based web app tick. 

Right now, the app is deployed to Heroku, and running smoothly. I plan on using Balder in general, from here on out and whenever possible for my hosting needs. Open source for the win, as they say. 

* Sidebar: I'd love to show you guys the results of the wedding, but since it was a personal affair, I would rather receive clearance before I share the results with the public. Thanks for understanding, all. 
