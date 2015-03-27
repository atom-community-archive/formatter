# Atom Formatter
The core dependency you need to support formatting services

Provides a service API that you can register by scope name to send Async formatting edits.

* Provides unified keyboard shortcuts
* Takes care of command resolution to the correct scope and therefore provider
* Takes care of applying the code edits in a manner that they can be easily undone (transactional)

# Providers

* [TypeScript](https://atom.io/packages/atom-typescript)


# API for Providers

Given you understand these simple concepts:
```ts
/** 0 based */
interface EditorPosition {
    line: number;
    col: number;
}

interface CodeEdit {
    start: EditorPosition;
    end: EditorPosition;
    newText: string;
}

interface Selection {
    start: EditorPosition;
    end: EditorPosition;
}
```

The Provider really needs to be a `FormatterProvider`. It needs to provide:
 * a selector for which it will work
 * a `getCodeEdits` function that gets passed in `FormattingOptions` and returns a bunch of `CodeEdit[]` or a promise thereof.

```ts
interface FormattingOptions {
    editor: AtomCore.IEditor;

    // only if there is a selection
    selection: Selection;
}

interface FormatterProvider {
    selector: string;
    disableForSelector?: string;
    getCodeEdits: (options: FormattingOptions) => CodeEdits[] | Promise<CodeEdit[]>;
}
```


## Sample Provider

**package.json**:

```json
"providedServices": {
  "formatter": {
    "versions": {
      "1.0.0": "provideFormatter"
    }
  }
}
```

**main.ts** / or js / or coffee or whatever

```ts
export function provideFormatter() {
    var formatter: FormatterProvider;
    formatter = {
        selector: '.source.ts',
        getCodeEdits: (options: FormattingOptions): Promise<CodeEdit[]> => {
            var filePath = options.editor.getPath();
            if (!options.selection) {
                return parent.formatDocument({ filePath: filePath }).then((result) => {
                    return result.edits;
                });
            }
            else {
                return parent.formatDocumentRange({
                  filePath: filePath,
                  start: options.selection.start,
                  end: options.selection.end })
                    .then((result) => {
                        return result.edits;
                    });
            }
        }
    };
    return formatter;
}
```
