# LG Smart TVs

(Or, corporate entitlement run amok.)

[According to a UK
blogger](http://doctorbeet.blogspot.co.uk/2013/11/lg-smart-tvs-logging-usb-fil
enames-and.html), LG Smart TVs not only offer "smart" features, but also
track your viewing habits _extremely_ closely by submitting events back to LG
and to LG's advertising affiliates.

Under his diagnosis, the TV sends an event to LG that identifies the specific TV

* every time the viewer changes channels (containing the name of the channel being watched)

* whenever a USB device is inserted (containing the names of files stored on the USB stick)

The page comments additionally suggest that the TV sends back information
whenever the menu is opened, as well.

This information is used to provide targetted advertising, likely to offset
the operational cost of the TV's "intelligent" features. Consumer protections
around personal data and tracking have traditionally been very weak, so it's
not entirely surprising that LG would choose to extract revenue this way
instead of raising the price of the product to cover the operational costs and instead of offering the intelligent features as a subscription service, but this is extremely disappointing.

## How is this harmful?

LG uses this information to sell [targeted
advertising](http://us.lgsmartad.com/main/main.lge), extracting value for
itself out from the presence of other peoples' eyeballs. We've collectively
chosen to accept that content producers -- website owners, for example -- can
sell advertising as a way to augment their income from the content they
produce. However, LG is not a content producer; while you can choose to leave
a website that uses invasive ad tracking, LG's position is more analogous to
that of the web browser itself: they get to watch the customer's habits no matter what they choose to watch.

LG's ability to correlate viewing habits across every channel and across
non-public media the user watches places them in a position where they may
well derive more information about the people watching TV than those peoples'
own spouses or parents would be trusted with. We've already seen this kind of
comprehensive statistical modelling go wrong; [Target's advertising folks
landed in hot water last
year](http://www.forbes.com/sites/kashmirhill/2012/02/16/how-target-figured-ou
 t-a-teen-girl-was-pregnant-before-her-father-did/) after their
purchase-habit-derived models revealed information about a customer that she
didn't even have about herself.

LG is also taking zero care to ensure that the private information it's
silently extracting from viewers is not diseminated further. The TV sends
viewing information - channel names, file names from USB sticks, and so on -
over the internet in plain text, allowing anyone on the network path between
the TV and LG to intercept it and use it for their own ends. This kind of
information is incredibly useful for targetted fraud, and I'm sure the NSA is
thrilled to have such a useful source of personally-identifying and
habit-revealing data available for free, too.

## Icing on the cake

The TV's settings menu contains an item entitled "Collection of watching
info" which can be turned to "On" (the default, even if the customer rejects
the end-user license agreement on the television and disables the
"intelligent" features) or "Off". It would be reasonable to expect that this
option would stop the TV from communicating viewing habits to the internet;
however, the setting appears to do very little. The article shows packet
captures of the TV submitting viewing information to LG with the setting in
either position.

The setting also has no help text to guide customers to understanding what it
_actually_ does or to clarify expectations around it.

## LG's stance is morally indefensible

From the blog post, LG's representative claims that viewers "agree" to this
monitoring when they accept the TV's end-user license agreement, and that
it's up to the retailer to inform the user of the contents of the license
agreement. However:

1. LG does not ensure that retailers tell potential buyers about the end-user license conditions; they claim it's up to the retailer's individual discretion.

2. There's no incentive for retailers to tell customers about the license agreement, as the agreement is between LG and the customer, not between the retailer and the customer. Stopping each sale to talk about license terms is likely to reduce the number of sales, too.

3. It would be impractical for retailers to inform customers of every license for every product they sell, as there are unique licenses for nearly every piece of software and for most computer-enabled products (i.e., most of them). Retailers do not habitually employ contract lawyers to accurately guide customers through the license agreements.

4. LG's own packaging makes the license agreement effectively unviewable without committing the money to buy a TV. It's only presented on the TV itself after it's installed and turned on (which often voids the customer's ability to return it to the retailer), and in retailer-specific parts of LG's own website, which isn't practically available while the customer is standing in a shop considering which TV to buy.

It is not reasonable to expect customers to assume their TV will track
viewing habits publicly. This is not a behaviour that TVs have had over their
multi-decade existence, and it's disingenuous for LG to act like the customer
"should have known" in any sense that the LG TV acts in this way.

LG is hiding behind the modern culture of unfair post-sale contracts to
justify a novel, deeply-invasive program of customer monitoring, relying on
corporate law to protect themselves from consumer reprisals. This cannot be
allowed to continue; vote with your dollars.
