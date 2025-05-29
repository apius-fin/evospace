from jinja2 import Environment, FileSystemLoader
import os

# Function for rendering the template and saving the result
def generate_html():
    # Set the directory for templates (at the root of the project)
    template_dir = os.path.join(os.getcwd())  # Root of the project
    file_loader = FileSystemLoader(template_dir)
    env = Environment(loader=file_loader)

    # Load the template 'template.html'
    template = env.get_template('template.html')

    # Data that we pass to the template
    variables = {
        'css_path': 'Static',
        'favicon_path': 'Static/Images',
        'non_planet_path': 'Static/Images/Inside',
        'planet_path': 'Static/Images/Planet'
    }

    # Render the template with the variables
    rendered_html = template.render(variables)

    # Save the result to the file 'index.html'
    with open('../index.html', 'w') as f:
        f.write(rendered_html)

    print("HTML file has been generated and saved as index.html.")

# Main entry point of the program
if __name__ == '__main__':
    generate_html()