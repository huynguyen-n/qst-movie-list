# ``QSTUI``

A set of components that you can integrate into your app to view the movie list.

## Overview

The easiest way to integrate QSTUI is by using ``MovieView``.

```swift
// Present modally
Text("Movies").sheet(isPresented: $isMoviePresented) {
    NavigationView {
        MovieView()
    }
}
```
