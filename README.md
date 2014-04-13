# [gulp](http://gulpjs.com)-gulp-retina-sprites

> Convert images automatically to retina sprites.

Currently only supports .png Files

## Install

```
npm install --save-dev gulp-gulp-retina-sprites
```


## Example

```js
var gulp = require('gulp');
var gulp-retina-sprites = require('gulp-gulp-retina-sprites');

gulp.task('default', function () {
	gulp.src('static/*.png')
		.pipe(gulp-retina-sprites())
		.pipe(gulp.dest('dist'));
});
```


## License

MIT

Copyright (c) 2014 [efa GmbH](http://efa-gmbh.com/), [Ferdinand Full](https://github.com/medialwerk)
