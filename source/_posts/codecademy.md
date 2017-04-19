---
title: CodeCademy
toc: 1
date: 2017-04-18 15:30:56
tags:
- codecademy
categories:
- 自主学习
permalink:
---
**原因**：2017年4月18日 星期二 其实是在学英语
**说明**：学无止境哦。

<!-- more -->

## Learn HTML & CSS : Part 1 (1)
### What is HTML?

> HTML is the language used to create the web pages you visit everyday. It provides a logical way to structure content for web pages.


- Let's analyze the acronym "HTML", as it contains a lot of useful information. HTML stands for `HyperText Markup Language`.
- A `markup` language is a computer language that defines the structure and presentation of raw text. Markup languages work by surrounding raw text with information the computer can interpret, "marking it up" for processing.
- HyperText is text displayed on a computer or device that provides access to other text through links, also known as “hyperlinks”. In fact, you probably clicked on many, many hyperlinks on your path to this Codecademy course!
- In this course, you'll learn how to use the fundamentals of HTML to structure, present, and link content. You'll also learn how to use CSS, or Cascading Style Sheets, to style the HTML content you add to web pages.
- Let's get started!

---

### !DOCTYPE
>A web browser must know what language a document is written in before they can process the contents of the document.

- You can let web browsers know that you are using the HTML language by starting your HTML document with a document type declaration.
- The declaration is the following:

```
<!DOCTYPE html>
```

- This declaration is an instruction. It tells the browser what type of document to expect, along with what version of HTML is being used in the document. `<!DOCTYPE html>`must be the first line of code in all of your HTML documents.

> Note: If you don't use the doctype declaration, your HTML code will likely still work, however, it's risky. Right now, the browser will correctly assume that you are using HTML5, as HTML5 is the current standard. In the future, however, a new standard will override HTML5. Future browsers may assume you're using a different, newer standard, in which case your document will be interpreted incorrectly. To make sure your document is forever interpreted correctly, always include <!DOCTYPE html> at the very beginning of your HTML documents.

---

### Preparing for HTML
- Great! Browsers that read your code will know to expect HTML when they attempt to read your file.
- The `<!DOCTYPE html>` declaration is only the beginning, however. It only tells the browser that you plan on using HTML in the document, it doesn't actually add any HTML structure or content.
- To begin adding HTML structure and content, we must first add opening and closing `<html>` tags, like so:

```
<!DOCTYPE html>
<html>

</html>
```

- Anything between `<html>` and `</html>`will be considered HTML code. Without these tags, it's possible that browsers could incorrectly interpret your HTML code and present HTML content in unexpected ways.

---

### HTML Anatomy
- Before we move forward, let's standardize some vocabulary we'll use as you learn HTML. Here are some of the terms you'll see used in this course:
- Angle brackets - In HTML, the characters < and > are known as angle brackets.
HTML element (or simply, element) - HTML code that lives inside of angle brackets.
- Opening tag - the first, or opening, HTML tag used to start an HTML element.
Closing tag - the second, or closing, HTML tag used to end an HTML element. Closing tags have a forward slash (/) inside of them.
- With the exception of a few HTML elements, most elements consist of an opening and closing tag.

>In the following example, there is one paragraph element, made up of one opening tag (`<p>`) and one closing tag (`</p>`):
`<p>Hello there!</p>`

### THe Head
- So far, you've declared to the browser the type of document it can expect (an HTML document) and added the HTML element` (<html>)` that will contain the rest of your code. Let's also give the browser some information about the page. We can do this by adding a `<head>` element.
- The `<head>` element will contain information about the page that isn't displayed directly on the actual web page (you'll see an example in the next exercise).

```
<!DOCTYPE html>
<html>
  <head>

  </head>
</html>
```

---

### Page Title
- What kind of information about the web page can the `<head>` element contain?
- Well, if you look at the top of your browser (or at one of the tabs you may have open in this browser window), you'll notice the words Learn HTML & CSS: Part I | Codecademy, which is the title of this web page.
- The browser displays the title of the page because the title can be specified directly inside of the `<head>` element, by using a `<title>` element.

```
<!DOCTYPE html>
<html>
  <head>
    <title>My Coding Journal</title>
  </head>
</html>
```
- If we were to open a file containing the HTML code in the example above, the browser would display the words My Coding Journal in the title bar (or in the tab's title).

---

### The Body
- We've added some HTML, but still haven't seen any results in the web browser to the right. Why is that?
- Before we can add content that a browser will display, we have to add a body to the HTML file. Once the file has a body, many different types of content can be added within the body, like text, images, buttons, and much more.

```
<!DOCTYPE html>
<html>
  <head>
    <title>I'm Learning To Code!</title>
  </head>
  <body>

  </body>
</html>
```
- All of the code above demonstrates what is sometimes referred to as "boilerplate code."
- The term "boilerplate code" is used to describe the basic HTML code required to begin creating a web page. Without all of the elements in the boilerplate code, you'll risk starting without the minimum requirements considered to be best practice.

>Note: The rest of the course will use code examples like the one above. To save space, however, code examples will avoid including common elements like the declaration, head, and so on. Unless otherwise specified, you can assume that the code in the example code blocks belongs directly within the HTML file's body.

---

### Review : Structure

>Congratulations on completing the first unit of HTML & CSS! You are well on your way to becoming a skilled web developer.
Let's review what you've learned so far:
The <!DOCTYPE html> declaration should always be the first line of code in your HTML files.
The <html> element will contain all of your HTML code.
Information about the web page, like the title, belongs within the <head> of the page.
You can add a title to your web page by using the <title> element, inside of the head.
Code for visible HTML content will be placed inside of the <body> element.
What you learned in this lesson constitutes the required setup for all HTML files. The rest of the course will teach you more about how to add content using HTML and how to style that content using CSS!

---

## Learn HTML & CSS : Part 1 (2)
### Visible Content 
- In the last unit, you learned about the minimum amount of HTML code required to successfully structure a web page, sometimes referred to as "boilerplate code."
- We added a declaration, a head, a title, and a body, but we still need content that the web browser can display. In this unit, we'll learn how to use some of the most common HTML elements that add content to web pages.
- Keep in mind that HTML was originally created to markup, or present, text. The first few units of this course will focus solely on how HTML can be used to mark up text. Later in the course, we'll dive deeper into more advanced styling techniques using CSS.
- Let's get started!

---

### Headings

- Headings in HTML can be likened to headings in other types of media. For example, in newspapers, large headings are typically used to capture a reader's attention. Other times, headings are used to describe content, like the title of a movie or an educational article.
- HTML follows a similar pattern. In HTML, there are six different headings, or heading elements. Headings can be used for a variety of purposes, like titling sections, articles, or other forms of content.
- The following is the list of heading elements available in HTML. They are ordered from largest to smallest in size.
- `<h1>` - used for main headings, all other smaller headings are used for subheadings.
`<h2>
<h3>
<h4>
<h5>
<h6>`
The following example code uses a headline intended to capture a reader's attention. It uses the largest heading available, the main heading element:

```
<h1>BREAKING NEWS</h1>
```

---

### Paragraphs
- Often times, headings are meant to emphasize or enlarge only a few words.
- If you want to add content in paragraph format, you can add a paragraph using the paragraph element `<p>`.

```
<p>The Nile River is the longest river in the world, measuring over 6,850 kilometers long (approximately 4,260 miles). It flows through eleven countries, including Tanzania, Uganda, Rwanda, Burundi, Congo-Kinshasa, Kenya, Ethiopia, Eritrea, South Sudan, Sudan, and Egypt.</p>
```

- Paragraphs are great for expanding the amount of content (text) on your web page. As you begin to add more text to your web page, however, keep in mind that large amounts of text in paragraph format can overwhelm web page visitors. For example, if multiple paragraphs on your web page each contain large amounts of text, your web page could become difficult to consume.

---

### Unordered Lists
- Often times, it's better to display certain types of content in an easy-to-read list.
- In HTML, you can use the unordered list for text you decide to format in bullet points. An unordered list outlines individual list items with a bullet point. You've probably used an unordered list when writing down a grocery list or school supplies list.
- To create a unordered list using HTML, you can use the `<ul>` element. The `<ul>` element, however, cannot hold raw text and cannot automatically format raw text with bullet points. Individual list items must be added to the unordered list using the `<li>` element.

```
<ul>
  <li>Limes</li>
  <li>Tortillas</li>
  <li>Chicken</li>
</ul>
```
- In the example above, the list was created using the `<ul>` element and all individual list items were added using `<li>` elements.

---

### Ordered Lists
- Great job! Some lists, however, will require a bit more structure. HTML provides the ordered list when you need the extra ordering that unordered lists don't provide.
- Ordered lists are like unordered lists, except that each list item is numbered. You can create the ordered list with the `<ol>` element and then add individual list items to the list using `<li>` elements.

```<ol>
  <li>Preheat the oven to 350 degrees.</li>
  <li>Mix whole wheat flour, baking soda, and salt.</li>
  <li>Cream the butter, sugar in separate bowl.</li>
  <li>Add eggs and vanilla extract to bowl.</li>
```

---

### Links
- You're off to a great start! So far, you've learned how to add headings, paragraphs, and lists to a web page. We wouldn't be taking advantage of the full power of HTML (and the Internet), however, if we didn't link to other web pages.
- You can add links to a web page by adding an anchor element `<a>` and including the text of the link in between the opening and closing tags.

```
<a>This Is A Link To Wikipedia</a>
```

- Wait a minute! Technically, the link in the example above is incomplete. How exactly is the link above supposed to work if there is no URL that will lead users to the actual Wikipedia page?
- The anchor element in the example above is incomplete without the href attribute.
- Attributes provide even more information about an element's content. They live directly inside of the opening tag of an element. Attributes are made up of the following two parts:
- The name of the attribute.
- The value of the attribute.
- For anchor elements, the name of the attribute is href and its value must be set to the URL of the page you'd like the user to visit.

```
<a href="https://www.wikipedia.org/">This Is A Link To Wikipedia</a>
```
- In the example above, the `href` attribute has been set to the value of the correct URL https://www.wikipedia.org/. The example now shows the correct use of an anchor element.

>Note: When reading technical documentation, you may come across the term hyperlink. Not to worry, this is simply the technical term for link and, often times, these terms are used interchangeably

---

### More Link Attributes
- Have you ever clicked on a link and observed the resulting web page open in a new browser window? If so, you can thank the anchor element's target attribute.
- The target attribute specifies that a link should open in a new window. Why is it beneficial to open links in a new window?
- It's possible that one or more links on your web page link to an entirely different website. In that case, you may want users to read the linked website, but hope that they return to your web page. This is exactly when the target attribute is useful!
- For a link to open in a new window, the target attribute requires a value of _blank. The target attribute can be added directly to the opening tag of the anchor element, just like the href attribute.

```
<a href="https://en.wikipedia.org/wiki/Brown_bear" target="_blank">The Brown Bear</a>
```
- In the example above, the link would read The Brown Bear and open up the relevant Wikipedia page in a new window.

>Note: In this exercise, we've used the terminology "open in a new window." It's highly likely that you are using a modern browser that opens up websites in new tabs, rather than new windows. Before the advent of browsers with tabs, additional browser windows had to be opened to view more websites. The target attribute, when used in modern browsers, will open new websites in a new tab.

---

### Images
- All of the elements you've learned about so far (headings, paragraphs, lists, and links) all share one thing in common: they're composed entirely of text! What if you want to add content to your web page that isn't composed of text, like images?
- The `<img>` element lets you add images to a web page. This element is special because it does not have a closing tag, it only has an opening tag. This is because the `<img>` element is a self-closing element.

```
<img src="https://www.example.com/picture.jpg" />
```

>Note that the `<img>` element has a required attribute called src, which is similar to the href attribute in links. In this case, the value of src must be the URL of the image. Also note that the end of the `<img>` element has a forward slash /. This is required for a self-closing element.

---

### ALt
- Part of being an exceptional web developer is making your site accessible to users of all backgrounds. Specifically, visually impaired users require more support from your web page so that they can experience the content on your page.
- HTML helps support visually impaired users with the alt attribute.
- The alt attribute is applied specifically to the `<img>` element. The value of alt should be a description of the image.

```
<img src="#" alt="A field of yellow sunflowers" />
```
- The alt attributes also serves the following purposes:

>If an image fails to load on a web page, a user can mouse over the area originally intended for the image and read a brief description of the image. This is made possible by the description you provide in the alt attribute.
Visually impaired users often browse the web with the aid of of screen reading software. When you include the alt attribute, the screen reading software can read the image's description outloud to the visually impaired user.
Note: If the image on the web page is not one that conveys any meaningful information to a user (visually impaired or otherwise), the alt attribute should not be used.

---

### Linking At Will
- You've probably visited websites where not all links were made up of text. Maybe the links you clicked on were images, or some other form of content.
- So far, we've added links that were made up of only text, like the following:

```
<a href="https://en.wikipedia.org/wiki/Opuntia" target="_blank">Prickly Pear</a>
```
- Text-only links, however, would significantly decrease your flexibility as a web developer!
- Thankfully, HTML allows you to turn nearly any element into a link by wrapping that element with an anchor element. With this technique, it's possible to turn images into links by simply wrapping the `<img>` element with an `<a>` element.

```
<a href="https://en.wikipedia.org/wiki/Opuntia" target="_blank"><img src="#" alt="A red prickly pear fruit"/></a>
```
In the example above, an image of a prickly pear has been turned into a link by wrapping the outside of the `<img>` element with an `<a>` element.

---

### White Space
- It's important to understand that the formatting of the code in index.html will not affect the positioning of the elements within the browser.
- For example, if you wanted to increase the space between a paragraph and an image on your web page, you would not be able to accomplish this by simply adding more spacing between the paragraph element and image element within index.html. This is because the browser ignores whitespace present in HTML files like index.html.
- On the other hand, using whitespace in HTML files is important so that your code is easy to read and follow.
- For example, the following code is difficult to read and understand:

```
<html><head></head>
<body><h1>Hello!</h1><p>This is a paragraph!</body>
</html>
```
- The following code, however, uses spacing effectively to make it easier to read:

```
<html>
<head>
  <title>My Web Page</title>
</head>
<body>
  <h1>Hello!</h1>
  <p>This is a paragraph!</p>
</body>
</html>
```

---

### Line Breaks
- You saw how modifying the spacing between code in an HTML file doesn't affect the positioning of elements in the browser. If you are interested in modifying the spacing in the browser, you can use HTML's line break element: `<br />`.

- The line break element is one self-closing tag. You can use it anywhere within your HTML code and a line break will be shown in the browser.

- Shall I compare thee to a summer's day?`<br />`Thou art more lovely and more temperate
- The code in the example above will result in an output that looks like the following:

- Shall I compare thee to a summer's day?
- Thou art more lovely and more temperate

>Note: Line breaks are not the standard way of manipulating the positioning of HTML elements, but it's likely that you'll come across them every now and then. In later units, you'll learn more advanced techniques for positioning HTML elements.

---

### Indentation
- Whitespace makes code easier to read by increasing (or decreasing) the spacing between lines of code. To make the structure of code easier to read, web developers often use indentation.
- The World Wide Web Consortium (W3C) is responsible for maintaining the style standards of HTML. At the time of writing, the W3C recommends 2 spaces of indentation when writing HTML code. Indentation is intended for elements nested within other elements.

```
<ul>
  <li>Violin</li>
  <li>Viola</li>
  <li>Cello</li>
  <li>Bass</li>
<ul>
```
- In the example above, the list items are indented with two spaces. The spaces are inserted using the spacebar on your keyboard. Unless your text editor has been configured properly, the "TAB" key on your keyboard should not be used for indentation.

---

### Comments

- HTML files also allow you to add comments to your code.
- Comments begin with `<!-- and end with -->`. Any characters in between will be treated as a comment.

```
<!-- This is a comment that the browser will not display. -->
```
- Including comments in your code is helpful for many reasons:
- They help you (and others) understand your code if you decide to come back and review it at a much later date.
- They allow you to experiment with new code, without having to delete old code.

```
<!-- Favorite Films Section -->
<p>The following is a list of my favorite films:</p>
```
- In the example above, the comment is used to denote that the following text makes up a particular section of the page.

```
<!-- <a href="#" target="_blank>Codecademy</a> -->
```
- In the example above, a valid HTML element (an anchor element) has been "commented out." This practice is useful when you want to experiment with new code without having to delete old code.

---

### Review:Common Elements
- Congratulations on completing the second unit of HTML & CSS! In this unit, you learned how to add content to a web page using some of the most common HTML elements.
- Let's review what you've learned so far:
- You can add headings of different sizes using the different headings elements: `<h1`> through `<h6>`.
- Paragraphs are added with the `<p>` element.
- Unordered lists are created with the `<ul>` element and list items are added using the `<li>` element.
- Ordered lists are created with the `<ol>` element and list items are added using the `<li>` element.
- You can add links to your web page using the `<a>` element - don't forget the href attribute!
- Images can be added with the `<img>` element - don't forget the src attribute!
- Images help support visually impaired users when `<img>` elements include the alt attribute.
- You can turn anything into a link by wrapping it with an `<a>` element.
- White space in the HTML file does not affect the positioning of elements in the browser.
- The W3C recommends 2 spaces of indentation for nested HTML elements.
- Comments are used to take notes inside of an HTML file. You can add a comment with `<!-- This is a comment -->`.

---

## Learn HTML & CSS : Part 1 (3)
### What is CSS?
- So far, you've learned about the fundamentals of HTML, including the basic structure required to set up HTML files, as well as the common HTML elements used to add content to a web page.
- Unfortunately, the HTML elements that we've used to add content to a web page have resulted in fairly bland results in the browser. For example, it appears that all content seems to be the same color, have the same font, and offer no direct control over the size of the font (apart from the six different heading options). How can we make our HTML more visually appealing?
- CSS, or Cascading Style Sheets, is a language that web developers use to style the HTML content on a web page. If you're interested in modifying colors, font types, font sizes, shadows, images, element positioning, and more, CSS is the tool for the job!
- In this unit, you'll first learn how to incorporate CSS so that you can style content. You'll also learn about CSS's basic structure and learn how to use its syntax. In later units, we'll explore in detail exactly how to change color, font options, and much more.
- Let's begin!

---

### sytle
- Although CSS is a different language than HTML, it's possible to write CSS code directly within an HTML file. This is possible because of the `<style>` element.

The `<style>` element allows you to write CSS code between its opening and closing tags. To use the `<style>` element, it must be placed inside of the head.

```
<head>
  <style>

  </style>
</head>
```
Once `<style>` is placed in the web page's head, we can begin writing CSS code.

```
<head>
  <style>
    h2 {
    font-family: Arial;
    }
  </style>
</head>
```
- Don't worry about the CSS code in the example above just yet, you will learn more about the details of CSS code in later lessons.

---

### Structure vs Style

- Although the `<style>` element allows you to write CSS code within HTML files, this mixture of HTML and CSS can result in code that is difficult to read and maintain.
- It's common for developers to add substantial amounts of custom CSS styling to a web page. When all of that CSS code is placed within a `<style>` element in an HTML file, you risk the following two things:
- Creating a large HTML file that is difficult to read and maintain (by you and other developers). Overall, this can result in an inefficient workflow.
Maintaining a clear distinction between web page structure (HTML) and web page styling (CSS).

---

### The .css file
- Fortunately, the following solution will help you avoid creating large HTML files that mix in CSS code: a CSS file!
- HTML files are meant to contain only HTML code. Similarly, CSS files are meant to contain only CSS code. You can create a CSS file by using the .css file name extension, like so: style.css
- With a CSS file, you can write all the CSS code needed to style a page without having to sacrifice the readability and maintainability of your HTML file.

### Linking the CSS File
- Perfect! We successfully separated structure (HTML) from styling (CSS), but why does the web page look continue to look so bland? The CSS code now lives in a separate CSS file called style.css — shouldn't that have worked without issue?
- Not exactly. When HTML and CSS code are in separate files, the HTML file must know exactly where the CSS code is kept, otherwise, the styling can't be applied the web page. In order to apply the styling to the web page, we'll have to link the HTML file and the CSS file together.
- You can use the` <link>` element to link the HTML and CSS files together. The `<link>` element must be placed within the head of the HTML file. It is a self-closing tag and requires the following three attributes:
- href - like the anchor element, the value of this attribute must be the address, or path, to the CSS file.
- type - this attribute describes the type of document that you are linking to (in this case, a CSS file). The value of this attribute should be set to text/css.
- rel - this attribute describes the relationship between the HTML file and the CSS file. Because you are linking to a stylesheet, the value should be set to stylesheet.
- When linking an HTML file and a CSS file together, the <link> element will look like the following:

```
<link href="https://www.codecademy.com/stylesheets/style.css" type="text/css" rel="stylesheet">
```
Note that in the example above the path to the stylesheet is a URL:

- https://www.codecademy.com/stylesheets/style.css
- Specifying the path to the stylesheet using a URL is one way of linking a stylesheet.
- If the CSS file is stored in the same directory as your HTML file, then you can specify a relative path instead of a URL, like so:

```
<link href="/style.css" type="text/css" rel="stylesheet">
```
- Using a relative path is very common way of linking a stylesheet.

---

### Review:CSS Setup
- Great job! You learned how to link an HTML file and a CSS file together.
- Let's review what you've learned so far:
- HTML and CSS are kept in separate files in order to keep code maintainable and readable, as well as keep structure separate from styling.
- The `<style>` element allows you to write CSS code within an HTML file.
- A CSS stylesheet can be linked to an HTML file using the `<link>` element, which requires three attributes:
- href - set equal to the path of the CSS file.
- type - set equal to text/css.
- rel - set equal to stylesheet.
- In this lesson, you learned about the two different places in which you can write CSS code, but you didn't write any CSS code at all.
- In the next lesson, you'll learn about the basic structure and syntax of CSS so that you can start using CSS on your own.

---

