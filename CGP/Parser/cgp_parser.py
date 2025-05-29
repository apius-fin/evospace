#-----------------------------------------------------------------------------------
# Developed by Alexander Guzeew (@guzeew_alex) in December 2024
# All Rights reserved by the LICENSE. Copyright © 2024 Guzeew Alexander
#-----------------------------------------------------------------------------------

from playwright.sync_api import sync_playwright
import os
import sys

def type_os():
    package_manager = str(input("Enter the Linux distribution type (deb/rpm): ")).strip().lower()  # Clean up and convert to lowercase
    if package_manager not in ["deb", "rpm"]:
        print("Error: invalid value entered. Please enter 'deb' or 'rpm'.")
        sys.exit(1)  # Exit the script if the value is incorrect
    return package_manager

def run_playwright(package_manager):
    with sync_playwright() as p:
        # Get the path to the project root
        download_path = os.path.join(os.getcwd(), 'downloads')  # Path for downloads
        
        # Ensure that the folder exists
        os.makedirs(download_path, exist_ok=True)
        
        # Launch the Firefox browser and create a context
        browser = p.firefox.launch()
        context = browser.new_context(accept_downloads=True)  # Specify only accept_downloads
        page = context.new_page()
        
        # Open the website
        page.goto('https://communigatepro.ru')
        
        # Click the first button
        page.click('div.menu-open:nth-child(6) > div:nth-child(1) > a:nth-child(1)')
        
        try:
            # Wait for the block to appear after the first click for 3 seconds
            page.wait_for_selector('.tn-elem__8451643171712515270372 > div:nth-child(1)', timeout=3000)
            page.click('.tn-elem__8451643171712515270379 > div:nth-child(1) > a:nth-child(1)')
            # https://communigatepro.ru/server
            page.wait_for_selector('#rec844676922 > div:nth-child(2) > div:nth-child(1) > div:nth-child(2)', timeout=3000)
            if package_manager == "deb":
                page.click('.tn-elem__8446769221735052440322 > a:nth-child(1)')
            elif package_manager == "rpm":
                page.click('div.t396__elem:nth-child(36) > a:nth-child(1)')
        except:
            # If the block does not appear, click the second button
            print("The first block did not appear, clicking the second button.")
            page.click('.tn-elem__7947786241713744839614 > a:nth-child(1)')
            
            try:
                # Wait for the block to appear after the second click for 3 seconds
                page.wait_for_selector('.tn-elem__7428234401714102568894 > div:nth-child(1)', timeout=3000)
            except:
                # If the block does not appear after the second click, exit the script
                print("Error: the parser did not wait for the download window to appear.")
                # Close the context and browser
                context.close()
                browser.close()
                sys.exit(1)  # Exit the script since the download window did not appear
        
        # Click the button to download and wait for the file to download
        with page.expect_download(timeout=10000) as download_info:
            if package_manager == "deb":
                page.click('.tn-elem__7428234401714102916133 > a:nth-child(1)')
            elif package_manager == "rpm":
                page.click('.tn-elem__7428234401714102984618 > a:nth-child(1)')
        
        # Get the downloaded file information
        download = download_info.value
        print(f'File downloaded: {download.path}')
        
        # Move the file to the desired directory
        download_path_full = os.path.join(download_path, download.suggested_filename)
        download.save_as(download_path_full)
        print(f'File saved to: {download_path_full}')
        
        # Close the context and browser
        context.close()
        browser.close()

def main():
    package_manager = type_os()  # Get the package_manager value from type_os()
    run_playwright(package_manager)  # Pass the package_manager to run_playwright

if __name__ == "__main__":
    main()